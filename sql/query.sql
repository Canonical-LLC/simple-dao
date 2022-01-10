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

SELECT count_votes(E'\\x380eab015ac8e52853df3ac291f0511b8a1b7d9ee77248917eaeef10',
  ARRAY[E'\\xee155ace9c40292074cb6aff8c9ccdd273c81648ff1149ef36bcea6ebb8a3e25' :: hash32type,
        E'\\xbb30a42c1e62f0afda5f0a4e8a562f7a13a24cea00ee81917b86b89e801314aa',
        E'\\xe88bd757ad5b9bedf372d8d3f0cf6c962a469db61a265f6418e1ffed86da29ec',
        E'\\x642206314f534b29ad297d82440a5f9f210e30ca5ced805a587ca402de927342'],
        '2020-12-30 08:36:26');
