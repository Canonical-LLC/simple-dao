# Simple DAO

This repo demonstrates how to use UTxO datum hashes, transaction metadata and NFT goverance tokens to implement proposal creation and voting for a DAO.

The system does not use smart contracts, and is able to batch votes for very cheap per vote costs.

## Setup

The repo includes tests scripts for demonstrate the flow for proposal creation and voting.

### Node Selection

The tests scripts expect to use Daedalus and Daedalus Testnet for their nodes.

To choose the testnet run:

```bash
$ source scripts/envars/testnet
```

To use mainnet run:

```bash
$ source scripts/envars/mainnet
```

### Test Wallet Creation

To create the tests wallets run:

```bash
$ scripts/wallets/make-all-wallets.sh
```

## Proposal Creation

Proposals are transactions with proposal metadata. Here is what the metadata looks like:

```json
{
  "1" : {
    "url" : "https://proposal-description-url,
    "expiration": 1641854247
  }
}
```

`url` refers to a webpage that explains the proposal and the alternatives for voting.

`expiration` is a Unix epoch timestamp for when voting will end.

To create a proposal a transaction to the designated proposal address is made with the appropriate metadata.

Create a test example proposal run:

```bash
$ scripts/happy-path/proposal-tx.sh
Estimated transaction fee: Lovelace 176897
Transaction successfully submitted.
3835cf59f8275bbaff7e732b41bf1e7e9d480dab89a23d88c1f4c37e615abbf8
```

The final line is the transaction id. Keep track of it, because we need it for voting.

## Voting

Voting is accomplished by users of specific NFTs sending the NFTs to themselves along with tagging the UTxOs with datum hash that corresponds to a particular proposal alternative.

Before users can vote on an alternative, a hash for the proposal and alternative must be created. This is accomplished with the `hash-value` script which takes the proposal transaction id and alternative index.

```bash
$ ./scripts/hash-value.sh 3835cf59f8275bbaff7e732b41bf1e7e9d480dab89a23d88c1f4c37e615abbf8 1
++ cardano-cli transaction hash-script-data --script-data-value '[{ "bytes": "3835cf59f8275bbaff7e732b41bf1e7e9d480dab89a23d88c1f4c37e615abbf8" }, { "int" : 1 }]'
04c6e4693b10da67472000f68cd077ffb8026fb105e9c132a01ff3596648f174
```

As one can see the datum hash is made by constructing a json object with transaction id and the alternative index. This is feed to `cardano-cli transaction hash-script-data --script-data-value`.

Also notice that we used the transaction id from running `scripts/happy-path/proposal-tx.sh`.

The hash `04c6e4693b10da67472000f68cd077ffb8026fb105e9c132a01ff3596648f174` is globally unique because the transaction id is.

Voting is efficient and can be batched with other votes to reduce fees. To see an example look at `scripts/happy-path/multi-vote.sh`.

Run the example batch voting with:

```bash
$ scripts/happy-path/multi-vote.sh 3835cf59f8275bbaff7e732b41bf1e7e9d480dab89a23d88c1f4c37e615abbf8
```

## Tallying

Tallying votes occurs off-chain by counting the first vote for each goverance token. A `db-sync` based PostgreSQL function is included to help automate this task.

The function is:

```sql
CREATE OR REPLACE FUNCTION count_votes(hash28type, hash32type[], timestamp without time zone) RETURNS TABLE(data_hash hash32type, vote_count int) AS $$
  SELECT p.data_hash, COUNT(p.name) AS vote_count
  FROM
    ( SELECT DISTINCT ON (ma.name)
         tx_out.data_hash AS data_hash
       , b.time
       , ma.name AS name
      FROM tx_out
      INNER JOIN tx ON (tx.id = tx_out.tx_id)
      INNER JOIN block AS b ON (tx.block_id = b.id)
      INNER JOIN ma_tx_out AS m ON (m.tx_out_id = tx_out.id)
      INNER JOIN multi_asset AS ma ON (ma.id = m.ident)
      WHERE ma.policy = $1
        AND tx_out.data_hash = ANY($2)
        AND b.time < $3
      ORDER BY ma.name, b.time DESC
    ) AS p
  GROUP BY p.data_hash
  ORDER BY vote_count DESC
$$
LANGUAGE SQL;
```

It is invoked by calling:

```sql
SELECT count_votes(E'\\x380eab015ac8e52853df3ac291f0511b8a1b7d9ee77248917eaeef10',
  ARRAY[E'\\x94ac4c62a94a6e776454b481d16ed04d98ff6235f7b6ff2d188ac8d6199b561a' :: hash32type,
        E'\\xac73be5cfc34c33b956ae76b265c07b03cd902adceb298064051302fb9e9f400',
        E'\\x0490e8f546440bad01fdaa9b78159f5df4066981a22669d9f3114c4578263ffd',
        E'\\xe512abb47ac76180cc001f5bde2eaf239ab61383d049e8524ce9fd028572fa6c'],
        '2022-12-30 08:36:26');
```

The first argument is the policy id for the goverance NFT, the second is the list of proposal hashes, and the final argument is the expiration period.

Running the query will produce output like:

```
                                count_votes
---------------------------------------------------------------------------
 ("\\x94ac4c62a94a6e776454b481d16ed04d98ff6235f7b6ff2d188ac8d6199b561a",4)
 ("\\x0490e8f546440bad01fdaa9b78159f5df4066981a22669d9f3114c4578263ffd",2)
 ("\\xac73be5cfc34c33b956ae76b265c07b03cd902adceb298064051302fb9e9f400",2)
 ("\\xe512abb47ac76180cc001f5bde2eaf239ab61383d049e8524ce9fd028572fa6c",1)
```

The winning alternative will be listed first, in this case `94ac4c62a94a6e776454b481d16ed04d98ff6235f7b6ff2d188ac8d6199b561a`.
