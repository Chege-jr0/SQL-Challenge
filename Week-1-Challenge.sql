-- Village location table
CREATE TABLE village_locations (
    village_id INTEGER NOT NULL PRIMARY KEY,
    village VARCHAR(30) NOT NULL,
    latitude VARCHAR(30),
    longitude VARCHAR(30),
    total_population INTEGER
);

INSERT INTO village_locations VALUES (1 ,'Dharkenley','4°47''35.40"','45°12''28.80"', 1000);
INSERT INTO village_locations VALUES(2,'Bulo-Kahin','4°47''57.00"','45°11''5.70"',2000);
INSERT INTO village_locations VALUES (3,'Hilo Kelyo','4°47''57.00"','45°12''58.60"',5212);
INSERT INTO village_locations VALUES(4,'Xubow','4°46''46.77"','45°12''7.57"',2590);
INSERT INTO village_locations VALUES(5,'Xiintooy','4°44''14.40"','45°13''5.00"',3000);
INSERT INTO village_locations VALUES(6,'Dhagax Jebis','4°44''27.86"','45°12''42.03"',3563);

-- Beneficiary Partner Data table
CREATE TABLE beneficiary_partner_data (
    partner_id INTEGER PRIMARY KEY,
    partner VARCHAR(100),
    village VARCHAR(100),
    beneficiaries INTEGER,
    beneficiary_type VARCHAR(50)
);

INSERT INTO beneficiary_partner_data VALUES(1,'IRC','Balcad','1450','Individuals');
INSERT INTO beneficiary_partner_data VALUES(2,'NRC','Balcad','50','Households');
INSERT INTO beneficiary_partner_data VALUES(3,'SCI','Balcad','1123','Individuals');
INSERT INTO beneficiary_partner_data VALUES(4,'IMC','Balcad','1245','Individuals');
INSERT INTO beneficiary_partner_data VALUES(5,'SCI','Mareeray','5200','Individuals');
INSERT INTO beneficiary_partner_data VALUES(6,'IMC','Mareeray','70','Households');

DROP TABLE jurisdiction_hierarchy;
-- Table jurisdiction-hieracrchy
CREATE TABLE jurisdiction_hierarchy (
	location_id     INT PRIMARY KEY AUTO_INCREMENT,
    region_name   VARCHAR(50) NOT NULL,
    district_name VARCHAR(50) NOT NULL,
    village_name  VARCHAR(50) 
);

INSERT INTO jurisdiction_hierarchy VALUES(1,'Middle Shabelle','Region',NULL);
INSERT INTO jurisdiction_hierarchy VALUES(2,'Hiraan','Region',NULL);
INSERT INTO jurisdiction_hierarchy VALUES(3,'Balcad','District','Middle Shabelle');
INSERT INTO jurisdiction_hierarchy VALUES(4,'Jowhar','District','Middle Shabelle');
INSERT INTO jurisdiction_hierarchy VALUES(5,'Beledweyn','District','Hiraan');
INSERT INTO jurisdiction_hierarchy VALUES(6,'Dharkenley','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(7,'Bulo-Kahin','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(8,'Hilo Kelyo','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(9,'Xubow','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(10,'Xiintooy','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(11,'Dhagax Jebis','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(12,'Filtare','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(13,'Howl-Wadaag','Village','Beledweyn');
INSERT INTO jurisdiction_hierarchy VALUES(14,'Balcad','Village','Balcad');
INSERT INTO jurisdiction_hierarchy VALUES(15,'Mareeray','Village','Balcad');
INSERT INTO jurisdiction_hierarchy VALUES(16,'Kulmis','Village','Balcad');
INSERT INTO jurisdiction_hierarchy VALUES(17,'Sabuun','Village','Jowhar');
INSERT INTO jurisdiction_hierarchy VALUES(18,'Bayaxaw','Village','Jowhar');

-- Create District_summary view
CREATE VIEW district_summary AS
WITH village_info AS (
  SELECT 
    jh_v.region_name AS village,
    jh_v.village_name AS district,
    jh_d.village_name AS region
  FROM jurisdiction_hierarchy jh_v
  JOIN jurisdiction_hierarchy jh_d ON jh_d.region_name = jh_v.village_name
  WHERE jh_v.district_name = 'Village'
    AND jh_d.district_name = 'District'
),
benef_per_village AS (
  SELECT 
    village,
    SUM(CASE WHEN beneficiary_type = 'Households' THEN beneficiaries * 6.0 ELSE beneficiaries END) AS ind_benef
  FROM beneficiary_partner_data
  GROUP BY village
),
pop_per_district AS (
  SELECT 
    vi.district,
    SUM(COALESCE(vl.total_population, 0)) AS total_pop
  FROM village_info vi
  LEFT JOIN village_locations vl ON vl.village = vi.village
  GROUP BY vi.district
)
SELECT 
  vi.district AS "District Name",
  vi.region AS "Region Name",
  COALESCE(SUM(bpv.ind_benef), 0) AS "No. of Individual Beneficiaries",
  CASE 
    WHEN pop_per_district.total_pop = 0 THEN NULL 
    ELSE COALESCE(SUM(bpv.ind_benef), 0) / pop_per_district.total_pop 
  END AS "No. of Individual Beneficiaries / Total District Population"
FROM village_info vi
LEFT JOIN benef_per_village bpv ON bpv.village = vi.village
JOIN pop_per_district ON pop_per_district.district = vi.district
GROUP BY vi.district, vi.region, pop_per_district.total_pop;

-- Create Partner_summary view
CREATE VIEW partner_summary AS
SELECT 
    bpd.partner AS "Partner Name",
    COUNT(DISTINCT bpd.village) AS "No. of Villages reached by partner",
    COUNT(DISTINCT jh.village_name) AS "No. of Districts reached by partner"
FROM beneficiary_partner_data bpd
JOIN jurisdiction_hierarchy jh ON bpd.village = jh.region_name AND jh.district_name = 'Village'
GROUP BY bpd.partner;
GROUP BY bpd.partner;
