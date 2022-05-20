hdfs dfs -rm -r projectdata
hdfs dfs -rm -r projectschema

sqoop import-all-tables  --connect jdbc:mysql://ip-10-1-1-204.ap-south-1.compute.internal:3306/anabig114225 --username anabig114225 --password Bigdata123 --compression-codec=snappy --as-avrodatafile --warehouse-dir=/user/anabig114225/projectdata --m 1 --driver com.mysql.jdbc.Driver

hdfs dfs -mkdir projectschema
hdfs dfs -copyFromLocal ~/*.avsc projectschema


hive -f create_database_table_pipeline_sql.sql > output.txt