--QUESTION 1
SELECT COUNT(u_id)
FROM wave;

--QUESTION 2
SELECT COUNT(transfer_id)
FROM transfers WHERE send_amount_currency = 'CFA';

--QUESTION 3
SELECT COUNT(u_id)
FROM transfers WHERE send_amount_currency = 'CFA';

--QUESTION 4
SELECT COUNT(atx_id)
FROM agent_transactions
WHERE EXTRACT(YEAR FROM when_created)=2018
GROUP BY EXTRACT(MONTH FROM when_created);

--QUESTION 5
WITH agentwithdrawers AS
(SELECT COUNT(agent_id) AS netwithdrawers
FROM agent_transactions WHERE amount > -1
AND amount !=0 HAVING COUNT(amount)>(SELECT COUNT(amount)
FROM agent_transactions WHERE amount < 1 AND amount !=0))
SELECT netwithdrawers FROM agentwithdrawers;

--QUESTION 6
SELECT COUNT(atx.amount) AS "atx volume city summary" ,ag.city
FROM agent_transactions AS atx LEFT OUTER JOIN agents AS ag ON
atx.atx_id = ag.agent_id
WHERE atx.when_created BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
AND NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER
GROUP BY ag.city;

--QUESTION 7
SELECT COUNT(atx.atx_id) AS "atx volume",COUNT(ag.city) AS "city",COUNT(ag.country) AS "country"
FROM agent_transactions AS atx INNER JOIN agents AS ag ON 
atx.atx_id = ag.agent_id
GROUP BY ag.country;

--QUESTION 8
SELECT wallets.ledger_location AS "country", agent_transactions.send_amount_currency AS "Transfer_Kind",
SUM(agent_transactions.send_amount_scalar) AS "volume"
FROM transfers AS agent_transactions INNER JOIN wallets ON agent_transactions.transfer_id = wallets.wallet_id
WHERE agent_transactions.when_created = CURRENT_DATE - INTERVAL '1 week'
GROUP BY wallets.ledger_location ,agent_transactions.send_amount_currency;

--QUESTION 9
SELECT COUNT(transfers.source_wallet_id) AS unique_senders, COUNT(transfer_id)
AS transaction_count, transfers.kind AS transfer_kind, wallets.ledger_location 
AS country,
SUM(transfers.send_amount_scalar) AS volume FROM transfers INNER JOIN wallets
ON transfers.source_wallet_id = wallets.wallet_id
WHERE(transfers.when_created > (NOW() - INTERVAL '1 week'))
GROUP BY wallets.ledger_location, transfers.kind;

--QUESTION 10
SELECT source_wallet_id, send_amount_scalar 
FROM transfer
WHERE send_amount_currency = 'CFA' AND send_amount_scalar>10000000 
AND when_created > CURRENT_DATE - INTERVAL '1 month';
