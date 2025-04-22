-- Author: Emil Chávez

-- ==============================================
-- Unique users by stage (page)
SELECT 
  'Home' AS stage, 
  COUNT(DISTINCT user_id) AS users,
  ROUND(100.0, 2) AS pct_from_home
FROM clean_home

UNION ALL

SELECT 
  'Search',
  COUNT(DISTINCT user_id),
  ROUND(100.0 * COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM clean_home), 2)
FROM clean_search

UNION ALL

SELECT 
  'Payment',
  COUNT(DISTINCT user_id),
  ROUND(100.0 * COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM clean_home), 2)
FROM clean_payment

UNION ALL

SELECT 
  'Confirmation',
  COUNT(DISTINCT user_id),
  ROUND(100.0 * COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM clean_home), 2)
FROM clean_confirmation;

-- =================================================
-- Where do we have to most drop?
SELECT 
  COUNT(DISTINCT s.user_id) AS search_users,
  COUNT(DISTINCT p.user_id) AS payment_users,
  ROUND(100.0 * COUNT(DISTINCT p.user_id) / COUNT(DISTINCT s.user_id), 2) AS pct_pass_to_payment
FROM clean_search s
LEFT JOIN clean_payment p ON s.user_id = p.user_id;

-- ==========================================
-- Drop by stages II 
SELECT 
  'From home to Search' AS Stage, 
  ROUND(100.0 * COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM clean_home), 2) AS Stage_Drop_Rate
FROM clean_search

UNION ALL

SELECT 
  'From search to payment',
  ROUND(100.0 * COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM clean_search), 2)
FROM clean_payment

UNION ALL

SELECT 
  'From payment to confirmation',
  ROUND(100.0 * COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM clean_payment),2)
FROM clean_confirmation;

-- =================================================
-- Where do we have to most drop?
SELECT 
  COUNT(DISTINCT s.user_id) AS search_users,
  COUNT(DISTINCT p.user_id) AS payment_users,
  ROUND(100.0 * COUNT(DISTINCT p.user_id) / COUNT(DISTINCT s.user_id), 2) AS pct_pass_to_payment
FROM clean_search s
LEFT JOIN clean_payment p ON s.user_id = p.user_id;

-- ======================================
-- Drop my gender
SELECT 
  u.sex AS gender,
  COUNT(DISTINCT h.user_id) AS home_users,
  COUNT(DISTINCT s.user_id) AS search_users,
  COUNT(DISTINCT p.user_id) AS payment_users,
  COUNT(DISTINCT c.user_id) AS confirmation_users
FROM clean_users u
LEFT JOIN clean_home h ON u.user_id = h.user_id
LEFT JOIN clean_search s ON u.user_id = s.user_id
LEFT JOIN clean_payment p ON u.user_id = p.user_id
LEFT JOIN clean_confirmation c ON u.user_id = c.user_id
GROUP BY u.sex;

-- ================================
-- DROP by gender in pct
SELECT 
  u.sex AS gender,
  COUNT(DISTINCT h.user_id) AS home_users,
  ROUND(100.0 * COUNT(DISTINCT s.user_id) / COUNT(DISTINCT h.user_id), 2) AS search_pct,
  ROUND(100.0 * COUNT(DISTINCT p.user_id) / COUNT(DISTINCT h.user_id), 2) AS payment_pct,
  ROUND(100.0 * COUNT(DISTINCT c.user_id) / COUNT(DISTINCT h.user_id), 2) AS confirmation_pct
FROM clean_users u
LEFT JOIN clean_home h ON u.user_id = h.user_id
LEFT JOIN clean_search s ON u.user_id = s.user_id
LEFT JOIN clean_payment p ON u.user_id = p.user_id
LEFT JOIN clean_confirmation c ON u.user_id = c.user_id
GROUP BY u.sex;

-- =============================
-- Confirmed Users by month
SELECT 
  DATE_FORMAT(u.date, '%Y-%m') AS month,
  COUNT(DISTINCT c.user_id) AS confirmed_users,
  ROUND(100.0 * COUNT(DISTINCT c.user_id) / COUNT(DISTINCT h.user_id), 2) AS conversion_rate_from_home
FROM clean_users u
JOIN clean_home h ON u.user_id = h.user_id
LEFT JOIN clean_confirmation c ON u.user_id = c.user_id
GROUP BY month
ORDER BY month;


-- ================================
-- Qty by stage grouped by DEVICE
SELECT 
  u.device,
  COUNT(DISTINCT h.user_id) AS home_users,
  COUNT(DISTINCT s.user_id) AS search_users,
  COUNT(DISTINCT p.user_id) AS payment_users,
  COUNT(DISTINCT c.user_id) AS confirmation_users
FROM clean_users u
LEFT JOIN clean_home h ON u.user_id = h.user_id
LEFT JOIN clean_search s ON u.user_id = s.user_id
LEFT JOIN clean_payment p ON u.user_id = p.user_id
LEFT JOIN clean_confirmation c ON u.user_id = c.user_id
GROUP BY u.device;

-- ================================
-- drop-off % by device
SELECT 
  u.device,
  COUNT(DISTINCT h.user_id) AS home_users,
  ROUND(100.0 * COUNT(DISTINCT s.user_id) / COUNT(DISTINCT h.user_id), 2) AS search_pct,
  ROUND(100.0 * COUNT(DISTINCT p.user_id) / COUNT(DISTINCT h.user_id), 2) AS payment_pct,
  ROUND(100.0 * COUNT(DISTINCT c.user_id) / COUNT(DISTINCT h.user_id), 2) AS confirmation_pct
FROM clean_users u
LEFT JOIN clean_home h ON u.user_id = h.user_id
LEFT JOIN clean_search s ON u.user_id = s.user_id
LEFT JOIN clean_payment p ON u.user_id = p.user_id
LEFT JOIN clean_confirmation c ON u.user_id = c.user_id
GROUP BY u.device;

-- COMMENTS:
/* Mobile users convert 4x more than Desktop (1.00% vs. 0.25%)
Payment drop is higher on Desktop (only 5% reach payment)
Mobile performs better across all stages
Desktop users may be dropping during checkout */ 




