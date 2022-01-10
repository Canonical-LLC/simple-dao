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
  ARRAY[E'\\x94ac4c62a94a6e776454b481d16ed04d98ff6235f7b6ff2d188ac8d6199b561a' :: hash32type,
        E'\\xac73be5cfc34c33b956ae76b265c07b03cd902adceb298064051302fb9e9f400',
        E'\\x0490e8f546440bad01fdaa9b78159f5df4066981a22669d9f3114c4578263ffd',
        E'\\xe512abb47ac76180cc001f5bde2eaf239ab61383d049e8524ce9fd028572fa6c'],
        '2020-12-30 08:36:26');
