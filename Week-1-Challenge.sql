-- Beneficiary Partner Data table
CREATE TABLE beneficiary_partner_data (
    partner_id INTEGER PRIMARY KEY,
    partner VARCHAR(100),
    village VARCHAR(100),
    beneficiaries INTEGER,
    beneficiary_type VARCHAR(50)
);

-- District_summary view Table
CREATE VIEW district_summary AS
SELECT 
    jh.district AS "District Name",
    jh.region AS "Region Name",
    SUM(bpd.beneficiaries) * 6 AS "No. of Individual Beneficiaries",
    (SUM(bpd.beneficiaries) * 6.0) / MAX(jh.district_population) AS "No. of Individual Beneficiaries / Total District Population"
FROM jurisdiction_hierarchy jh
JOIN beneficiary_partner_data bpd ON jh.village = bpd.village
WHERE bpd.beneficiary_type = 'HH'
GROUP BY jh.district, jh.region;

-- Create Partner_summary view
CREATE VIEW partner_summary AS
SELECT 
    bpd.partner AS "Partner Name",
    COUNT(DISTINCT bpd.village) AS "No. of Villages reached by partner",
    COUNT(DISTINCT jh.district) AS "No. of Districts reached by partner"
FROM beneficiary_partner_data bpd
JOIN jurisdiction_hierarchy jh ON bpd.village = jh.village
GROUP BY bpd.partner;
