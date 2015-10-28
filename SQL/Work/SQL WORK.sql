SELECT 	t1.name,
	t2.specificity AS memory,
	t3.computers_id AS cpu,
	t5.specificity AS disksize1
FROM glpi_computers AS t1 
INNER JOIN glpi_computers_devicememories AS t2 ON t2.computers_id = t1.id
INNER JOIN glpi_computers_deviceprocessors AS t3 ON t3.computers_id = t1.id
INNER JOIN (
  SELECT computers_id, CONCAT (specificity) as specificity
  FROM glpi_computers_deviceharddrives as t4)
  AS t5
  ON t5.computers_id = t1.id
WHERE t1.id = 1294
LIMIT 10;

SELECT  t1.name,
	t2.specificity AS memory,
	COUNT(DISTINCT(t3.id)) AS cpu,
	GROUP_CONCAT(t5.specificity) AS disksize
FROM glpi_computers AS t1 
INNER JOIN glpi_computers_devicememories AS t2 ON t2.computers_id = t1.id
INNER JOIN glpi_computers_deviceprocessors AS t3 ON t3.computers_id = t1.id GROUP BY t1.name
INNER JOIN (
  SELECT computers_id, CONCAT (specificity) as specificity
  FROM glpi_computers_deviceharddrives as t4)
  AS t5
  ON t5.computers_id = t1.id
WHERE t1.id = 1294
LIMIT 10;

SELECT  t1.name,
	t2.specificity AS memory,
	t3.cpu_id AS cpu,
	t4.disklist AS disk,
	t5.ifacelist AS ifaces,
	t6.ifcount
FROM glpi_computers AS t1
INNER JOIN glpi_computers_devicememories AS t2 ON t2.computers_id = t1.id
INNER JOIN ( SELECT computers_id, COUNT(DISTINCT(id)) as cpu_id FROM glpi_computers_deviceprocessors GROUP BY computers_id ) AS t3 ON t3.computers_id = t1.id
INNER JOIN ( SELECT computers_id, GROUP_CONCAT(specificity SEPARATOR ';') AS disklist FROM glpi_computers_deviceharddrives GROUP BY computers_id ) AS t4 ON t4.computers_id = t1.id
INNER JOIN ( SELECT items_id as computers_id, COUNT(DISTINCT(ip)) as ifcount FROM glpi_networkports GROUP BY computers_id ) AS t6 ON t6.computers_id = t1.id
INNER JOIN ( SELECT items_id as computers_id, GROUP_CONCAT(ip SEPARATOR ';') AS ifacelist FROM glpi_networkports GROUP BY computers_id ) AS t5 ON t5.computers_id = t1.id
WHERE t1.name LIKE '%PRDBDX%'
LIMIT 10;



# Afficher un serveur et la criticité de ses alertes en HNO

SELECT 	t1.name,
	t2.service AS service,
	t3.critical,
	t4.warning
FROM glpi_computers AS t1 
INNER JOIN (
  SELECT id, computers_id, CONCAT (service) as service FROM glpi_plugin_consigne_elements)
  AS t2
  ON t2.computers_id = t1.id
INNER JOIN (
  SELECT id, CONCAT (hno_call_critical) as critical FROM glpi_plugin_consigne_elements)
  AS t3
  ON t3.id = t2.id
INNER JOIN (
  SELECT id, CONCAT (hno_call_warning) as warning FROM glpi_plugin_consigne_elements)
  AS t4
  ON t4.id = t2.id
LIMIT 50;

SELECT glpi_computers.name, glpi_plugin_consigne_elements.service, glpi_plugin_consigne_elements.hno_call_warning, glpi_plugin_consigne_elements.hno_call_critical
FROM glpi_computers, glpi_plugin_consigne_elements
WHERE glpi_plugin_consigne_elements.computers_id = glpi_computers.id
LIMIT 50;

SELECT t1.servicegroup_id,
	t2.servicename,
	t3.hostname
FROM services_servicegroups AS t1
INNER JOIN (
	SELECT service_id, CONCAT (description) as servicename FROM services)
	AS t2
	ON t2.service_id = t1.service_id
INNER JOIN (
	SELECT host_id, CONCAT (name) as hostname FROM hosts)
	AS t3
	ON t3.host_id = t1.host_id
WHERE t1.servicegroup_id = 87
LIMIT 50;



SELECT hosts.name, services.description FROM services, hosts, services_servicegroups WHERE services.service_id = services_servicegroups.service_id AND services_servicegroups.host_id = hosts.host_id AND services_servicegroups.servicegroup_id = 87 LIMIT 10;
