BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "restaurant_restaurant" (
	"name"	varchar(100) NOT NULL,
	"address"	text NOT NULL,
	"phone"	varchar(20) NOT NULL,
	"email"	varchar(100) NOT NULL,
	"description"	text NOT NULL,
	"opening_hours"	text NOT NULL,
	"id"	char(32) NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_translation" (
	"language"	varchar(10) NOT NULL,
	"code"	varchar(10) NOT NULL,
	"description"	text NOT NULL,
	"id"	char(32) NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_bookingdetail" (
	"id"	char(32) NOT NULL,
	"quantity"	integer NOT NULL,
	"price"	decimal NOT NULL,
	"food_sub_quantity"	integer,
	"food_sub_price"	decimal,
	"deleted_at"	datetime,
	"booking_id"	char(32) NOT NULL,
	"food_id"	char(32) NOT NULL,
	"food_sub_id"	char(32),
	FOREIGN KEY("food_sub_id") REFERENCES "restaurant_foodsub"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("booking_id") REFERENCES "restaurant_booking"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("food_id") REFERENCES "restaurant_food"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_category" (
	"id"	char(32) NOT NULL,
	"name"	varchar(100) NOT NULL,
	"menu_id_id"	char(32) NOT NULL,
	"filter_code"	varchar(55) NOT NULL,
	"translation_id"	char(32) NOT NULL,
	FOREIGN KEY("translation_id") REFERENCES "restaurant_translation"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("menu_id_id") REFERENCES "restaurant_menu"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_categorysub" (
	"id"	char(32) NOT NULL,
	"name"	varchar(100) NOT NULL,
	"category_id_id"	char(32) NOT NULL,
	"translation_id"	char(32) NOT NULL,
	FOREIGN KEY("category_id_id") REFERENCES "restaurant_category"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("translation_id") REFERENCES "restaurant_translation"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_customer" (
	"id"	char(32) NOT NULL,
	"address"	text NOT NULL,
	"phone"	varchar(20) NOT NULL,
	"user_id"	char(32) NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "restaurant_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_food" (
	"id"	char(32) NOT NULL,
	"name"	varchar(100) NOT NULL,
	"description"	text NOT NULL,
	"price"	decimal NOT NULL,
	"image"	varchar(100) NOT NULL,
	"availability"	varchar(20) NOT NULL,
	"category_id"	char(32) NOT NULL,
	"category_sub_id"	char(32),
	"translation_id"	char(32) NOT NULL,
	FOREIGN KEY("category_sub_id") REFERENCES "restaurant_categorysub"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("category_id") REFERENCES "restaurant_category"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("translation_id") REFERENCES "restaurant_translation"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_foodsub" (
	"id"	char(32) NOT NULL,
	"name"	varchar(100) NOT NULL,
	"price"	decimal NOT NULL,
	"image"	varchar(100) NOT NULL,
	"availability"	varchar(20) NOT NULL,
	"food_id"	char(32) NOT NULL,
	"translation_id"	char(32) NOT NULL,
	FOREIGN KEY("translation_id") REFERENCES "restaurant_translation"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("food_id") REFERENCES "restaurant_food"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_menu" (
	"id"	char(32) NOT NULL,
	"name"	varchar(100) NOT NULL,
	"description"	text NOT NULL,
	"restaurant_id"	char(32) NOT NULL,
	FOREIGN KEY("restaurant_id") REFERENCES "restaurant_restaurant"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_mytable" (
	"id"	char(32) NOT NULL,
	"capacity"	integer NOT NULL,
	"status"	varchar(20) NOT NULL,
	"restaurant_id"	char(32) NOT NULL,
	"table_number"	varchar(10) NOT NULL,
	FOREIGN KEY("restaurant_id") REFERENCES "restaurant_restaurant"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_booking" (
	"id"	char(32) NOT NULL,
	"booking_date"	date NOT NULL,
	"booking_time"	text NOT NULL,
	"number_of_guests"	integer NOT NULL,
	"booking_status"	varchar(20) NOT NULL,
	"special_requests"	text NOT NULL,
	"booking_code"	varchar(100) NOT NULL,
	"booking_end_time"	time NOT NULL,
	"tax"	integer NOT NULL,
	"customer_id"	char(32) NOT NULL,
	"table_id"	char(32) NOT NULL,
	"duration"	integer NOT NULL,
	"total_price"	decimal NOT NULL,
	FOREIGN KEY("table_id") REFERENCES "restaurant_mytable"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("customer_id") REFERENCES "restaurant_customer"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "restaurant_user" (
	"id"	char(32) NOT NULL,
	"username"	varchar(100) NOT NULL,
	"password"	varchar(100) NOT NULL,
	"email"	varchar(100) NOT NULL,
	"fullname"	varchar(100) NOT NULL,
	PRIMARY KEY("id")
);
INSERT INTO "django_migrations" VALUES (1,'contenttypes','0001_initial','2024-04-28 08:48:58.417738'),
 (2,'auth','0001_initial','2024-04-28 08:48:58.435638'),
 (3,'admin','0001_initial','2024-04-28 08:48:58.448941'),
 (4,'admin','0002_logentry_remove_auto_add','2024-04-28 08:48:58.462255'),
 (5,'admin','0003_logentry_add_action_flag_choices','2024-04-28 08:48:58.471582'),
 (6,'contenttypes','0002_remove_content_type_name','2024-04-28 08:48:58.521789'),
 (7,'auth','0002_alter_permission_name_max_length','2024-04-28 08:48:58.534911'),
 (8,'auth','0003_alter_user_email_max_length','2024-04-28 08:48:58.547035'),
 (9,'auth','0004_alter_user_username_opts','2024-04-28 08:48:58.555091'),
 (10,'auth','0005_alter_user_last_login_null','2024-04-28 08:48:58.568133'),
 (11,'auth','0006_require_contenttypes_0002','2024-04-28 08:48:58.572134'),
 (12,'auth','0007_alter_validators_add_error_messages','2024-04-28 08:48:58.579135'),
 (13,'auth','0008_alter_user_username_max_length','2024-04-28 08:48:58.591188'),
 (14,'auth','0009_alter_user_last_name_max_length','2024-04-28 08:48:58.604189'),
 (15,'auth','0010_alter_group_name_max_length','2024-04-28 08:48:58.617242'),
 (16,'auth','0011_update_proxy_permissions','2024-04-28 08:48:58.624853'),
 (17,'auth','0012_alter_user_first_name_max_length','2024-04-28 08:48:58.635855'),
 (18,'restaurant','0001_initial','2024-04-28 08:48:58.662916'),
 (19,'sessions','0001_initial','2024-04-28 08:48:58.672917'),
 (20,'restaurant','0002_alter_booking_id_alter_customer_id_alter_food_id_and_more','2024-04-28 10:14:58.112892'),
 (21,'restaurant','0003_remove_food_menu_id_category_food_category_id','2024-04-28 10:20:46.506986'),
 (22,'restaurant','0004_booking_booking_code_booking_booking_end_time_and_more','2024-04-28 10:33:22.742885'),
 (23,'restaurant','0005_alter_food_image_alter_foodsub_image','2024-04-28 10:35:16.696196'),
 (24,'restaurant','0006_alter_booking_total_price_and_more','2024-04-28 10:37:24.530244'),
 (25,'restaurant','0007_categorysub_food_category_sub_id','2024-04-28 11:08:54.502542'),
 (26,'restaurant','0008_category_filter_code','2024-04-28 14:48:46.345616'),
 (27,'restaurant','0009_rename_customer_id_booking_customer_and_more','2024-04-28 14:54:01.779081'),
 (28,'restaurant','0010_booking_duration','2024-04-30 10:15:57.532694'),
 (29,'restaurant','0011_alter_mytable_table_number','2024-04-30 10:35:42.248585'),
 (30,'restaurant','0012_alter_booking_booking_time_alter_food_availability_and_more','2024-04-30 13:00:55.846498'),
 (31,'restaurant','0013_alter_booking_special_requests_and_more','2024-04-30 13:01:44.895964'),
 (32,'restaurant','0014_user_fullname_alter_food_availability_and_more','2024-04-30 15:35:47.646378');
INSERT INTO "django_admin_log" VALUES (1,'1','testuser',3,'',4,3,'2024-04-28 09:30:19.131023'),
 (2,'b8ed477a-e182-4394-b6e7-88d114d3e03c','Viet An',1,'[{"added": {}}]',9,3,'2024-04-28 10:15:55.179912'),
 (3,'79aca22c-66cd-4964-812a-e9c6af38098b','Menu object (79aca22c-66cd-4964-812a-e9c6af38098b)',1,'[{"added": {}}]',13,3,'2024-04-28 10:16:08.760152'),
 (4,'ea24d0e4-1400-48c0-a165-1fe2a96272a0','Translation object (ea24d0e4-1400-48c0-a165-1fe2a96272a0)',1,'[{"added": {}}]',10,3,'2024-04-28 10:17:12.649666'),
 (5,'d69921ca-8e6d-4610-aa38-9eea126c8cb6','Translation object (d69921ca-8e6d-4610-aa38-9eea126c8cb6)',1,'[{"added": {}}]',10,3,'2024-04-28 10:17:20.835173'),
 (6,'c7decc5c-8a1c-4b3d-8f44-2fe7796b3bb8','Category object (c7decc5c-8a1c-4b3d-8f44-2fe7796b3bb8)',1,'[{"added": {}}]',15,3,'2024-04-28 10:21:40.803807'),
 (7,'4419c107-3f23-469f-ad24-d6b0ddbac4cb','Category object (4419c107-3f23-469f-ad24-d6b0ddbac4cb)',1,'[{"added": {}}]',15,3,'2024-04-28 10:22:03.226740'),
 (8,'767167f5-7ecd-484f-abf7-9b5ca23f2ed3','Category object (767167f5-7ecd-484f-abf7-9b5ca23f2ed3)',1,'[{"added": {}}]',15,3,'2024-04-28 10:22:11.238308'),
 (9,'102fdc70-9024-4b75-a957-0f341b01ec2e','Summer Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 10:37:52.620060'),
 (10,'fde3f89f-20ed-4e28-9f8f-c3d17d2a1380','Vegetarian Summerr Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 10:40:25.649782'),
 (11,'b664c1b7-87e3-40ad-8d57-387fdb730d8b','Square Crab Spring Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 10:41:42.272419'),
 (12,'26405bc1-e425-44e5-a511-928181d5800e','Crispy Spring Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 10:42:40.984101'),
 (13,'989138e6-0832-4c29-9994-967b9e2d31dd','Vegetarian Spring Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 10:43:24.981283'),
 (14,'3d35deab-131e-4d19-88d3-a509b0088605','Prawn and Sweet Potato Fritters',1,'[{"added": {}}]',14,3,'2024-04-28 10:52:27.450062'),
 (15,'9573a573-80ca-4c6a-8a8c-878042546c78','Salt &  Pepper Chicken Wings',1,'[{"added": {}}]',14,3,'2024-04-28 10:53:29.404738'),
 (16,'85d224f7-f06a-425c-bdf7-65a5f3afda6b','Papaya Sallad',1,'[{"added": {}}]',14,3,'2024-04-28 10:54:40.317208'),
 (17,'25a546cd-2e44-4ff5-88e9-efaf2a90d898','Vietnamese Baguette',1,'[{"added": {}}]',14,3,'2024-04-28 10:56:03.999199'),
 (18,'523eb828-9677-4f22-9d11-a6a7b75d12fc','Chargrilled Pork Baguette',1,'[{"added": {}}]',14,3,'2024-04-28 10:57:40.733095'),
 (19,'c4e39ed0-77df-4100-845f-f6f20d3c6e4a','Grilled Chicken Baguette',1,'[{"added": {}}]',14,3,'2024-04-28 10:59:43.296448'),
 (20,'f32328ab-4c37-4932-a211-b964dd87e370','Vietnamese Pork Sausage and Fried Egg Baguette',1,'[{"added": {}}]',14,3,'2024-04-28 11:02:09.171982'),
 (21,'6a005aa9-6ad0-42be-bc4f-9bb1f88b5688','Steak Baguette',1,'[{"added": {}}]',14,3,'2024-04-28 11:03:59.101091'),
 (22,'259d21ae-2630-4b62-b933-a115bf95e598','Vegetarian Baguette',1,'[{"added": {}}]',14,3,'2024-04-28 11:07:46.971730'),
 (23,'7526d175-4cf5-4ede-b568-eaa3458dfa27','RICE',1,'[{"added": {}}]',18,3,'2024-04-28 11:09:34.530360'),
 (24,'ab5c5b89-d506-4c44-aaad-f171b3b3ac2d','RICE NOODLE SOUP',1,'[{"added": {}}]',18,3,'2024-04-28 11:09:45.230676'),
 (25,'8d6222df-6a5c-44b1-b929-cf04ea98a983','VERMICELLI NOODLES',1,'[{"added": {}}]',18,3,'2024-04-28 11:10:27.400083'),
 (26,'9f6fc5ce-e357-4a67-90c8-08827d6c7677','Ginger Chicken Rice',1,'[{"added": {}}]',14,3,'2024-04-28 13:51:03.726279'),
 (27,'ebf18027-e3b4-4423-9ebc-ba84949bf019','Chargrilled Pork Rice',1,'[{"added": {}}]',14,3,'2024-04-28 13:54:08.126935'),
 (28,'15311de4-4177-4b3d-aa65-5e91335ce106','Vegetarian Soup',1,'[{"added": {}}]',14,3,'2024-04-28 13:57:24.184455'),
 (29,'5d8e5d4e-292e-4be1-a09f-e9341dd94273','Beef Brisket Soup',1,'[{"added": {}}]',14,3,'2024-04-28 13:59:30.802494'),
 (30,'8233fe77-a66b-42f5-88ea-881ef1c1bd1f','Medium Rare Steak Soup',1,'[{"added": {}}]',14,3,'2024-04-28 14:00:51.070657'),
 (31,'01f679d2-f933-480c-bc70-9e036a963f5f','Short Beef Rib Soup',1,'[{"added": {}}]',14,3,'2024-04-28 14:02:20.143289'),
 (32,'d8d3b2a4-f3b0-45c6-8e1e-0a84b4abadd8','Oxtail and Rib Soup',1,'[{"added": {}}]',14,3,'2024-04-28 14:03:37.870738'),
 (33,'54cdc53a-9a7e-47a9-9320-658b452a2888','Beef Combo Soup',1,'[{"added": {}}]',14,3,'2024-04-28 14:04:59.374713'),
 (34,'d9daef93-9fe5-43be-a89f-0c351087ad5d','Chicken Pho Soup',1,'[{"added": {}}]',14,3,'2024-04-28 14:05:47.264855'),
 (35,'34922cdf-82eb-4333-bce2-6822e8cc4fc6','Chargrilled Pork',1,'[{"added": {}}]',14,3,'2024-04-28 14:08:31.953725'),
 (36,'6a216e2e-6145-4429-9f18-90445e463876','Crispy Spring Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 14:09:46.338947'),
 (37,'e22f2421-baa2-4bd5-a61f-d036b1b7eeb4','Square Crab Spring Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 14:11:07.645890'),
 (38,'f83a024a-9c41-4bda-a6a0-94f7bb86f469','Vegetarian Spring Rolls',1,'[{"added": {}}]',14,3,'2024-04-28 14:12:35.824138'),
 (39,'44125486-a06a-448e-bb25-0ee56be98f57','Chargrilled Pork or Crispy Spring Roll',1,'[{"added": {}}]',16,3,'2024-04-28 14:15:23.996056'),
 (40,'4659c2c4-38ec-415a-b387-6107baef2094','Square Crab Spring Roll',1,'[{"added": {}}]',16,3,'2024-04-28 14:16:12.212294'),
 (41,'5c8229e9-f16f-4d03-90b7-ce984316f377','Vegetarian Spring Rolls',1,'[{"added": {}}]',16,3,'2024-04-28 14:17:10.673902'),
 (42,'881c7586-cba2-4ee3-bf2d-e2c0822afd87','Vanilla Ice Cream',1,'[{"added": {}}]',14,3,'2024-04-28 14:18:33.052751'),
 (43,'1a669740-5f3b-4a89-a05d-4f2b81445d8c','Vietnamese Fruit Cocktail',1,'[{"added": {}}]',14,3,'2024-04-28 14:19:38.245893'),
 (44,'026f8139-4887-4716-8a8f-4db1acc59e98','Banana Fritters',1,'[{"added": {}}]',14,3,'2024-04-28 14:21:02.999261'),
 (45,'c7decc5c-8a1c-4b3d-8f44-2fe7796b3bb8','SMALL BITES',2,'[{"changed": {"fields": ["Filter code"]}}]',15,3,'2024-04-28 14:48:57.809301'),
 (46,'767167f5-7ecd-484f-abf7-9b5ca23f2ed3','DESSERTS',2,'[{"changed": {"fields": ["Filter code"]}}]',15,3,'2024-04-28 14:49:05.505217'),
 (47,'4419c107-3f23-469f-ad24-d6b0ddbac4cb','MAINS',2,'[{"changed": {"fields": ["Filter code"]}}]',15,3,'2024-04-28 14:49:12.524866'),
 (48,'b8ed477a-e182-4394-b6e7-88d114d3e03c','Viet An',2,'[{"changed": {"fields": ["Email"]}}]',9,3,'2024-04-30 08:50:53.150927'),
 (49,'94c94cba-1a94-4496-a0be-de5e5ce77ac9','MyTable object (94c94cba-1a94-4496-a0be-de5e5ce77ac9)',1,'[{"added": {}}]',8,3,'2024-04-30 10:34:49.150482'),
 (50,'a66512d5-3890-4367-bca3-9f3442ca3675','MyTable object (a66512d5-3890-4367-bca3-9f3442ca3675)',1,'[{"added": {}}]',8,3,'2024-04-30 10:34:56.424356'),
 (51,'e7185c20-cd9b-44f3-871e-95745f420a92','3',1,'[{"added": {}}]',8,3,'2024-04-30 10:36:05.613911'),
 (52,'77e8a4bb-70cd-49b6-896f-5b4bfe6011cd','4',1,'[{"added": {}}]',8,3,'2024-04-30 10:36:12.769757'),
 (53,'dc12d87f-a319-413c-9ede-14a368828c25','5',1,'[{"added": {}}]',8,3,'2024-04-30 10:36:25.374539'),
 (54,'d1bab56d-aecd-4e01-92f1-6a026a405aa4','6',1,'[{"added": {}}]',8,3,'2024-04-30 10:36:32.977043'),
 (55,'d1bab56d-aecd-4e01-92f1-6a026a405aa4','6',3,'',8,3,'2024-04-30 10:36:42.874299'),
 (56,'dc12d87f-a319-413c-9ede-14a368828c25','MyTable object (dc12d87f-a319-413c-9ede-14a368828c25)',2,'[{"changed": {"fields": ["Capacity"]}}]',8,3,'2024-04-30 13:36:36.390132'),
 (57,'e7185c20-cd9b-44f3-871e-95745f420a92','MyTable object (e7185c20-cd9b-44f3-871e-95745f420a92)',2,'[{"changed": {"fields": ["Capacity"]}}]',8,3,'2024-04-30 13:36:41.346810'),
 (58,'a66512d5-3890-4367-bca3-9f3442ca3675','MyTable object (a66512d5-3890-4367-bca3-9f3442ca3675)',2,'[{"changed": {"fields": ["Capacity"]}}]',8,3,'2024-04-30 13:36:47.075096'),
 (59,'94c94cba-1a94-4496-a0be-de5e5ce77ac9','MyTable object (94c94cba-1a94-4496-a0be-de5e5ce77ac9)',2,'[{"changed": {"fields": ["Capacity"]}}]',8,3,'2024-04-30 13:36:51.254472'),
 (60,'77e8a4bb-70cd-49b6-896f-5b4bfe6011cd','MyTable object (77e8a4bb-70cd-49b6-896f-5b4bfe6011cd)',2,'[{"changed": {"fields": ["Capacity"]}}]',8,3,'2024-04-30 13:36:55.202177'),
 (61,'fd32814b-d067-4c9c-b23b-7af913fe69c6','61088acb-d6a0-4457-8d01-455ae431648e',3,'',12,3,'2024-05-01 04:16:08.073389'),
 (62,'fc6c9385-9bf4-4576-8c00-d2370c52340b','1c879048-83e7-4b1f-a754-0fae5b3730c9',3,'',12,3,'2024-05-01 04:16:08.081874'),
 (63,'f6fd062f-4633-4598-9961-73d7fbb7b53b','e950cc0b-e896-4ce9-9ac0-53c0844f705e',3,'',12,3,'2024-05-01 04:16:08.084105'),
 (64,'f443964f-0d8e-4e2c-834c-acb9a870b706','eacab504-383a-4f46-8a18-9acea4a865fe',3,'',12,3,'2024-05-01 04:16:08.085973'),
 (65,'e848ce01-434e-45f7-9687-ef6cadebb76a','eacab504-383a-4f46-8a18-9acea4a865fe',3,'',12,3,'2024-05-01 04:16:08.088468'),
 (66,'d4f4fcd2-d2a4-4e37-848f-624d0050fcf3','ecfd8870-4400-4ba9-9808-c95f4fb8e3a1',3,'',12,3,'2024-05-01 04:16:08.091517'),
 (67,'c7466774-1abd-4ac9-ba92-208fc87abdee','ecfd8870-4400-4ba9-9808-c95f4fb8e3a1',3,'',12,3,'2024-05-01 04:16:08.093893'),
 (68,'bb97c71a-5a14-4e68-bdd1-a255fba84eee','21b8e7f1-4fd9-48ae-ad94-ffb313482e4d',3,'',12,3,'2024-05-01 04:16:08.095975'),
 (69,'b9a633e9-4616-4180-b6b0-c3e621176620','08b90b52-a54a-4e5b-b316-732a041afbd1',3,'',12,3,'2024-05-01 04:16:08.098939'),
 (70,'a2059e10-0848-4c05-8b70-a5f2d01945e1','0563b06a-6225-40ec-9fe7-487577370d60',3,'',12,3,'2024-05-01 04:16:08.102163'),
 (71,'9b054c15-ffb8-4d79-ae0f-d530174feef7','b5bfe58a-7703-419b-a3ca-e6c2fd14f8c0',3,'',12,3,'2024-05-01 04:16:08.104426'),
 (72,'927790da-3c9a-44ae-a31c-eb68b5522a0f','eacab504-383a-4f46-8a18-9acea4a865fe',3,'',12,3,'2024-05-01 04:16:08.107184'),
 (73,'8ca93d23-71e6-4965-978e-f7fa1b8a04d9','59bbc253-e7c2-421a-9e90-950625354b02',3,'',12,3,'2024-05-01 04:16:08.109546'),
 (74,'7687b336-17eb-494f-ad41-12c8969dc027','6cb912e7-a70f-4335-90ff-ccf18565e4ff',3,'',12,3,'2024-05-01 04:16:08.111388'),
 (75,'645efb4f-5ddd-4dce-b29e-77ca4ec1bde3','aeda478a-706d-4c7a-929a-cf8daf2baf22',3,'',12,3,'2024-05-01 04:16:08.113514'),
 (76,'61a70892-3855-4ae2-95a9-773ead9bac3a','0154ffec-94e4-4bc9-9bcb-2baf9f7d7cb3',3,'',12,3,'2024-05-01 04:16:08.117064'),
 (77,'5685eb4a-9f83-4bcf-b325-2d36cdc5c584','1a0fd738-efdb-45f2-8dab-32cb61e0c1de',3,'',12,3,'2024-05-01 04:16:08.119502'),
 (78,'5025bc69-6424-4772-a1d4-d2655d350087','4814f29f-c4b0-4bfb-a134-1312e8d7bb51',3,'',12,3,'2024-05-01 04:16:08.122349'),
 (79,'4abc3c7f-0725-4ed2-8e9a-ac2d26da4628','73aff5c7-e859-497b-8568-c2e6f7238f3f',3,'',12,3,'2024-05-01 04:16:08.124567'),
 (80,'4a240fb6-2388-4615-88a3-66cb4e938db1','1c879048-83e7-4b1f-a754-0fae5b3730c9',3,'',12,3,'2024-05-01 04:16:08.126480'),
 (81,'4570a1b7-f16b-4102-bfce-f7a4ff9ca0a1','e336f7b8-5fcc-4077-b74b-0cbe9c83fbda',3,'',12,3,'2024-05-01 04:16:08.128329'),
 (82,'37cd828f-bed9-4715-b601-fc1dcf710409','ad898275-6fe7-4a00-ae9f-ee7e1ae3ca65',3,'',12,3,'2024-05-01 04:16:08.130757'),
 (83,'33cbb902-d6f3-4b62-ae85-3940ba486ecd','527f5fb1-2a01-489c-90e4-9c948a5b1c9d',3,'',12,3,'2024-05-01 04:16:08.133266'),
 (84,'3279321d-4590-48bc-91a7-3b1a8d476c4e','4053e6ea-b536-43d5-98ad-d777b921502f',3,'',12,3,'2024-05-01 04:16:08.135174'),
 (85,'1efbc2ee-b285-4eb5-a2b6-8a10abebd32e','ad898275-6fe7-4a00-ae9f-ee7e1ae3ca65',3,'',12,3,'2024-05-01 04:16:08.137264'),
 (86,'118e21f9-6dd0-4e0f-a960-80c54a4ccabe','a676f026-d933-472c-a35f-6c7b8acf05a9',3,'',12,3,'2024-05-01 04:16:08.139560'),
 (87,'0fecb8bf-9337-4c1b-9f80-7322a9f1d2d9','eacab504-383a-4f46-8a18-9acea4a865fe',3,'',12,3,'2024-05-01 04:16:08.141725'),
 (88,'0d75fb02-906a-41ab-a0a5-4c7abd787f0a','e1714d5b-f203-4676-948e-4c4e5eaa526c',3,'',12,3,'2024-05-01 04:16:08.143630'),
 (89,'ddb82e75-f002-4d3b-908c-896ba2c32f70','9187d127-d80e-4c97-a6ee-039ac7d625fd',3,'',12,3,'2024-05-01 07:53:56.855708'),
 (90,'d51de687-668d-4bdc-baa8-bd1ea7c90578','ad6bff20-c1d1-44ab-af39-a1b1456f680d',3,'',12,3,'2024-05-01 07:53:56.860707'),
 (91,'d0b9c4ca-d0ff-43f0-a7a1-7020ea11daad','e58f3816-1361-4703-b0b7-46ff00f85d0c',3,'',12,3,'2024-05-01 07:53:56.864509'),
 (92,'ca09f516-4f83-4508-bb14-72e4b02347a9','ad6bff20-c1d1-44ab-af39-a1b1456f680d',3,'',12,3,'2024-05-01 07:53:56.868320'),
 (93,'b6ae5ffc-8f70-43a4-a352-d67b5612161b','1da4b37d-00f6-4cea-b443-6c63b416389e',3,'',12,3,'2024-05-01 07:53:56.871921'),
 (94,'b3bd4039-6548-4ab2-935a-063edc303836','f04d0103-8d45-4346-bd0c-76ebc8e5a42b',3,'',12,3,'2024-05-01 07:53:56.876244'),
 (95,'67f8603d-5b6d-4fc6-809b-41021291d8d3','dedc9234-7175-455f-aace-26f1b0b53004',3,'',12,3,'2024-05-01 07:53:56.881166'),
 (96,'46a3bc52-7940-4563-a4f7-b384da90b5ff','f04d0103-8d45-4346-bd0c-76ebc8e5a42b',3,'',12,3,'2024-05-01 07:53:56.885919'),
 (97,'f64583f2-0df4-4019-882d-0d29868c5016','f2ed9958-da24-4e9a-81a0-5c4db924ba16',3,'',12,3,'2024-05-01 08:30:00.891748'),
 (98,'e2409e66-0b27-48cd-b86c-0e2638c93ec8','f2ed9958-da24-4e9a-81a0-5c4db924ba16',3,'',12,3,'2024-05-01 08:30:00.901736'),
 (99,'bcc52876-4238-4373-b5e3-3678ab3515d5','fe345e89-f23c-4895-8585-d6028cf51bac',3,'',12,3,'2024-05-01 08:30:00.905736'),
 (100,'b2653239-3428-4058-83ed-da0fe128ba03','5577882e-624f-4304-95c0-9c2c7f1cbd78',3,'',12,3,'2024-05-01 08:30:00.910738'),
 (101,'a3b63a44-d6e9-4822-9f72-c1e2432559ef','825cd27d-c700-488d-9fb5-47007f1dbfb8',3,'',12,3,'2024-05-01 08:30:00.912563'),
 (102,'78bf1e5d-3a33-4ebf-9e7b-72a945c989ef','df981e2d-66e9-448e-8e2f-2ebbaf522e93',3,'',12,3,'2024-05-01 08:30:00.919497'),
 (103,'778f9b49-d998-4a83-af01-137bf8714595','5577882e-624f-4304-95c0-9c2c7f1cbd78',3,'',12,3,'2024-05-01 08:30:00.920416'),
 (104,'72f50da4-f5e8-4eec-a654-cc60eebb7321','388ec2c8-c8fe-44d5-93e5-f469c2db34a2',3,'',12,3,'2024-05-01 08:30:00.929581'),
 (105,'66b193cc-0ed9-4fb9-93cf-47a72a26f41a','5f9d50ee-06a1-4352-848c-78c5e74d4522',3,'',12,3,'2024-05-01 08:30:00.933566'),
 (106,'64b583dd-87a6-44da-8041-1e6a2a3edd9d','df4c1097-4a01-4548-903a-b183fc95dd71',3,'',12,3,'2024-05-01 08:30:00.938411'),
 (107,'484f6d33-6a72-49a2-8af6-2429162009d8','e563841f-af43-466e-8a34-eef5bcd94fb5',3,'',12,3,'2024-05-01 08:30:00.941438'),
 (108,'4077f6a5-b0dc-4f7a-b84a-30925602e93f','df4c1097-4a01-4548-903a-b183fc95dd71',3,'',12,3,'2024-05-01 08:30:00.941438'),
 (109,'3d14b6b5-70e4-44d9-be78-75041bd2e133','5f9d50ee-06a1-4352-848c-78c5e74d4522',3,'',12,3,'2024-05-01 08:30:00.941438'),
 (110,'1ef14a82-3af0-46d3-94c8-99da9cbd34d7','fe345e89-f23c-4895-8585-d6028cf51bac',3,'',12,3,'2024-05-01 08:30:00.941438'),
 (111,'fe863cef-0faf-4799-9e3f-d89fa1166080','7eca7971-4f77-4be9-8c7b-55933c627bd3',3,'',12,3,'2024-05-01 08:39:49.416349'),
 (112,'f475fa87-62d6-4c14-8f4e-f2ab204f19fa','47121b1a-2f0d-4a61-b303-9d6583ab6c96',3,'',12,3,'2024-05-01 08:39:49.421346'),
 (113,'e573aa16-b4e3-4bdb-b1ad-27c7949f0c6c','5332044c-ba8a-4f8c-8e75-6ea7671c6374',3,'',12,3,'2024-05-01 08:39:49.425795'),
 (114,'ca908d26-e1ab-4050-8568-7f5961d3cf19','c324402f-5dcd-4837-acb0-58e99ed789fd',3,'',12,3,'2024-05-01 08:39:49.429199'),
 (115,'c194a401-9028-4c9f-8617-7a16b7111f04','1e7620e3-c9aa-4c56-9bce-84fb3e4778b4',3,'',12,3,'2024-05-01 08:39:49.433123'),
 (116,'b7a06d97-e2cd-4f21-bd9b-e905434f8d18','bfefccaf-9afe-4c7b-8464-61e073d6fc49',3,'',12,3,'2024-05-01 08:39:49.436123'),
 (117,'a22c9c64-20c6-4c30-964b-2cbdc2f1e48e','32934a5b-4ce9-4a31-880a-f2b8e8d22a13',3,'',12,3,'2024-05-01 08:39:49.440068'),
 (118,'a1cf0199-89c7-4e18-a4ef-5e72abdd5b51','184854a1-3d91-43e9-aa67-e2b1298345da',3,'',12,3,'2024-05-01 08:39:49.444071'),
 (119,'90f74139-3443-4f7b-a7a5-3e9c0cb7e850','ef87553d-fb02-49ff-b712-9e8cac1d6f26',3,'',12,3,'2024-05-01 08:39:49.448068'),
 (120,'8b640f29-012a-4e3c-9538-e2d92ca2f139','32934a5b-4ce9-4a31-880a-f2b8e8d22a13',3,'',12,3,'2024-05-01 08:39:49.451652'),
 (121,'7f51f5d4-913b-4cb6-aadd-2b8f809581cd','c324402f-5dcd-4837-acb0-58e99ed789fd',3,'',12,3,'2024-05-01 08:39:49.455651'),
 (122,'7dd5eb64-b884-408e-904d-ad69b6ba6c24','f3ee75ff-4cb4-4ce1-9067-e8450be18c46',3,'',12,3,'2024-05-01 08:39:49.459913'),
 (123,'7dd22619-e590-4bef-8db7-819fc3800dc4','1e7620e3-c9aa-4c56-9bce-84fb3e4778b4',3,'',12,3,'2024-05-01 08:39:49.463913'),
 (124,'4349d96d-2e55-4f90-9b97-04f69bbdd667','4f60101b-2354-4416-95ec-ccd2385df77b',3,'',12,3,'2024-05-01 08:39:49.466876'),
 (125,'35a8745d-cd4f-4d47-a684-30fef23e3698','ef87553d-fb02-49ff-b712-9e8cac1d6f26',3,'',12,3,'2024-05-01 08:39:49.470876'),
 (126,'24c98094-627a-45cb-ac9a-e48bc03ed2a6','47121b1a-2f0d-4a61-b303-9d6583ab6c96',3,'',12,3,'2024-05-01 08:39:49.473876'),
 (127,'16128018-a6c1-4253-816f-02b32a386051','bfefccaf-9afe-4c7b-8464-61e073d6fc49',3,'',12,3,'2024-05-01 08:39:49.478214'),
 (128,'126f6224-2958-4bac-b826-a087e1bad2e8','7eca7971-4f77-4be9-8c7b-55933c627bd3',3,'',12,3,'2024-05-01 08:39:49.482723'),
 (129,'11f47bf4-ded7-4e58-b3ee-6386ba667dc7','f3ee75ff-4cb4-4ce1-9067-e8450be18c46',3,'',12,3,'2024-05-01 08:39:49.486723'),
 (130,'095a40d5-82cb-4442-be84-6ec5c8ec397b','184854a1-3d91-43e9-aa67-e2b1298345da',3,'',12,3,'2024-05-01 08:39:49.489723'),
 (131,'0114a911-644e-4311-9ce3-0de3b5ae54a0','4f60101b-2354-4416-95ec-ccd2385df77b',3,'',12,3,'2024-05-01 08:39:49.494551'),
 (132,'da0f0b2d-e5e7-4f49-bb87-77a4c4f2e8fd','6f8992fc-b1ff-41e6-be76-8e9586949402',3,'',12,3,'2024-05-01 08:51:40.690288'),
 (133,'bd85df7b-fc23-49f2-a16b-63ff0bb5dc21','d4040714-f9b3-4476-94b4-b79059e2acb6',3,'',12,3,'2024-05-01 08:51:40.695677'),
 (134,'b19ed025-9473-4d70-a12c-387a6e35114a','63920a01-e487-4664-bb36-23750c314fc1',3,'',12,3,'2024-05-01 08:51:40.699675'),
 (135,'8c09e7b8-20fc-4070-92db-5ba07e8805dc','4d1278fe-ac78-4382-97e5-b0d76a11b781',3,'',12,3,'2024-05-01 08:51:40.704675'),
 (136,'5e784905-53fb-470d-af49-f64c8d4316cf','63920a01-e487-4664-bb36-23750c314fc1',3,'',12,3,'2024-05-01 08:51:40.708352'),
 (137,'5da0e59a-b80a-433c-850b-8ee4166dfcd1','6f8992fc-b1ff-41e6-be76-8e9586949402',3,'',12,3,'2024-05-01 08:51:40.712921'),
 (138,'32d271cc-155d-49db-8600-b1e2e7734080','56858cec-866f-42cf-a7c0-6e47121f8203',3,'',12,3,'2024-05-01 08:51:40.716956'),
 (139,'15f649a7-6ada-4b74-859c-15039d89660f','56858cec-866f-42cf-a7c0-6e47121f8203',3,'',12,3,'2024-05-01 08:51:40.720951'),
 (140,'102fdc70-9024-4b75-a957-0f341b01ec2e','Summer Rolls',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:20:44.569681'),
 (141,'fde3f89f-20ed-4e28-9f8f-c3d17d2a1380','Vegetarian Summer Rolls VG',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:21:09.707349'),
 (142,'b664c1b7-87e3-40ad-8d57-387fdb730d8b','Square Crab Spring Rolls',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:21:32.632256'),
 (143,'26405bc1-e425-44e5-a511-928181d5800e','Crispy Spring Rolls',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:21:49.224890'),
 (144,'989138e6-0832-4c29-9994-967b9e2d31dd','Vegetarian Spring Rolls VG',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:22:05.418542'),
 (145,'3d35deab-131e-4d19-88d3-a509b0088605','Prawn and Sweet Potato Fritters',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:22:19.683272'),
 (146,'9573a573-80ca-4c6a-8a8c-878042546c78','Salt &  Pepper Chicken Wings',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:22:32.184299'),
 (147,'85d224f7-f06a-425c-bdf7-65a5f3afda6b','Papaya Salad VG',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:22:50.041094'),
 (148,'25a546cd-2e44-4ff5-88e9-efaf2a90d898','Vietnamese Baguette',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:23:02.412636'),
 (149,'523eb828-9677-4f22-9d11-a6a7b75d12fc','Chargrilled Pork Baguette',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:23:13.848636'),
 (150,'c4e39ed0-77df-4100-845f-f6f20d3c6e4a','Grilled Chicken Baguette',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:23:25.352618'),
 (151,'f32328ab-4c37-4932-a211-b964dd87e370','Vietnamese Pork Sausage and Fried Egg Baguette',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:23:36.019833'),
 (152,'6a005aa9-6ad0-42be-bc4f-9bb1f88b5688','Steak Baguette',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:23:47.232772'),
 (153,'259d21ae-2630-4b62-b933-a115bf95e598','Vegetarian Baguette',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:23:56.276389'),
 (154,'9f6fc5ce-e357-4a67-90c8-08827d6c7677','Ginger Chicken Rice',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:24:35.725927'),
 (155,'ebf18027-e3b4-4423-9ebc-ba84949bf019','Chargrilled Pork Rice',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:24:44.330402'),
 (156,'15311de4-4177-4b3d-aa65-5e91335ce106','Vegetarian Pho VG',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:25:51.634003'),
 (157,'5d8e5d4e-292e-4be1-a09f-e9341dd94273','Beef Brisket Pho',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:26:04.578075'),
 (158,'8233fe77-a66b-42f5-88ea-881ef1c1bd1f','Medium Rare Steak Soup',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:26:14.087118'),
 (159,'01f679d2-f933-480c-bc70-9e036a963f5f','Short Beef Rib Pho',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:26:27.197930'),
 (160,'d8d3b2a4-f3b0-45c6-8e1e-0a84b4abadd8','Oxtail and Rib Soup',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:26:39.335420'),
 (161,'54cdc53a-9a7e-47a9-9320-658b452a2888','Beef Pho Combo',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:26:53.759979'),
 (162,'d9daef93-9fe5-43be-a89f-0c351087ad5d','Chicken Pho',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:27:03.593657'),
 (163,'34922cdf-82eb-4333-bce2-6822e8cc4fc6','Chargrilled Pork Vermicelli',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:27:29.468695'),
 (164,'6a216e2e-6145-4429-9f18-90445e463876','Crispy Spring Rolls Vermicelli',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:27:42.604136'),
 (165,'e22f2421-baa2-4bd5-a61f-d036b1b7eeb4','Square Crab Spring Rolls Vermicelli',2,'[{"changed": {"fields": ["Name", "Description"]}}]',14,3,'2024-05-01 12:27:53.440733'),
 (166,'f83a024a-9c41-4bda-a6a0-94f7bb86f469','Vegetarian Spring Rolls',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:28:08.031883'),
 (167,'881c7586-cba2-4ee3-bf2d-e2c0822afd87','Vanilla Ice Cream',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:28:18.815693'),
 (168,'1a669740-5f3b-4a89-a05d-4f2b81445d8c','Vietnamese Fruit Cocktail',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:28:27.392491'),
 (169,'026f8139-4887-4716-8a8f-4db1acc59e98','Banana Fritters',2,'[{"changed": {"fields": ["Description"]}}]',14,3,'2024-05-01 12:28:35.942372'),
 (170,'ff8927c5-47d2-4667-a61d-c1c8cadf7169','cf7f6630-72d8-4ef8-819e-5eab45259df9',3,'',12,3,'2024-05-01 12:42:14.787902'),
 (171,'a1414460-48e7-47c2-9468-b0a3370ea1fa','8ff6836f-34d0-4d51-888d-8a5ef3958aad',3,'',12,3,'2024-05-01 12:42:14.792901'),
 (172,'9d5d9006-4dc9-4b8d-891c-e8fb124d7cf9','b063b893-f807-47be-904d-a93f3cb44e3f',3,'',12,3,'2024-05-01 12:42:14.797902'),
 (173,'9c8de31b-9515-48db-a3ce-24af564ee78d','b063b893-f807-47be-904d-a93f3cb44e3f',3,'',12,3,'2024-05-01 12:42:14.801900'),
 (174,'9af2599d-8ed7-4892-8711-e6c806c073d7','fff99bc8-eaf8-4461-b7b6-30ef0ac8c960',3,'',12,3,'2024-05-01 12:42:14.805899'),
 (175,'8a8a4f89-8d77-47e6-a3dc-400702513b87','24bc4eda-855d-4f1e-9f26-28510bd30cbb',3,'',12,3,'2024-05-01 12:42:14.809903'),
 (176,'89baf65b-cd3e-4da0-b5c8-8518690a32eb','54e650bc-050e-4098-a974-04d7d8b4cb67',3,'',12,3,'2024-05-01 12:42:14.815030'),
 (177,'55df7a51-083c-4ee0-90b7-98769d7a1a74','fff99bc8-eaf8-4461-b7b6-30ef0ac8c960',3,'',12,3,'2024-05-01 12:42:14.819032'),
 (178,'4f39b273-75d2-4f40-ac45-ceaf6235a0c8','7d30d853-144c-4885-bbbd-da7351282ecc',3,'',12,3,'2024-05-01 12:42:14.823029'),
 (179,'403e77cd-2369-4631-aaf5-0bc549af3a54','b063b893-f807-47be-904d-a93f3cb44e3f',3,'',12,3,'2024-05-01 12:42:14.828030'),
 (180,'367f727e-cad6-4f6c-960f-6ebcf112cc67','b063b893-f807-47be-904d-a93f3cb44e3f',3,'',12,3,'2024-05-01 12:42:14.832595'),
 (181,'1b84d22b-550c-4f77-9f61-f9913855b522','c8b3d175-85d6-42f9-9bd0-e581673ea290',3,'',12,3,'2024-05-01 12:42:14.836593'),
 (182,'18a9e1f7-072b-409d-9aeb-e0a4495dc94f','2079d535-678f-4d06-ac22-f0fa160c9170',3,'',12,3,'2024-05-01 12:42:14.841593'),
 (183,'004b0496-669a-4b0e-9c54-8ed31a3a006a','f00d2ab3-9fe9-4303-be93-67736298a6c9',3,'',12,3,'2024-05-01 12:42:14.845592'),
 (184,'c3512fa1-3843-4470-bf94-6b0a928bbc18','b8f56353-64e4-4335-8b61-61de4cf46fcf',3,'',12,3,'2024-05-03 11:36:43.057077'),
 (185,'b896a502-3bae-4ebd-82ab-99eb8f6737d5','994d0dbc-0ec0-44f8-8d70-15b5138c4fde',3,'',12,3,'2024-05-03 11:36:43.063625'),
 (186,'b1b5b538-86a6-44c2-97f9-0eb09d29fe1c','98db93a7-b952-4ab7-ac14-dd66072dd069',3,'',12,3,'2024-05-03 11:36:43.068737'),
 (187,'a822b2cc-abd0-42e1-8481-b4ee50a74649','31eedd51-0dff-45cc-a8d7-aeb31aaf9f0a',3,'',12,3,'2024-05-03 11:36:43.075769'),
 (188,'8230ede4-a7aa-402b-9970-a786ce6bc077','1616ac8d-9e21-492d-afd1-13f5b2360aa6',3,'',12,3,'2024-05-03 11:36:43.081812'),
 (189,'7f8143ae-4dca-4943-b40b-55c2e01e7749','31eedd51-0dff-45cc-a8d7-aeb31aaf9f0a',3,'',12,3,'2024-05-03 11:36:43.087322'),
 (190,'76608291-7063-4e42-bdb5-6bae0f6b115a','cf69f7ed-29cc-4685-9dce-2bf5519dc8cc',3,'',12,3,'2024-05-03 11:36:43.093441'),
 (191,'66187ec0-6407-4d98-8c92-44cb3b184976','994d0dbc-0ec0-44f8-8d70-15b5138c4fde',3,'',12,3,'2024-05-03 11:36:43.098334'),
 (192,'4a14d0ad-49ac-4f66-bc89-b01c65199146','cf69f7ed-29cc-4685-9dce-2bf5519dc8cc',3,'',12,3,'2024-05-03 11:36:43.105944'),
 (193,'42ed10c6-72da-454b-af7a-51c7e9ae5261','2fda16ac-49fa-4a5e-a58a-0df1f44a0c75',3,'',12,3,'2024-05-03 11:36:43.114203'),
 (194,'a12099ab-9fa9-48dd-a8fb-3fee23ad6f5c','aeac1872-922b-44ef-9614-2f1638ca5545',3,'',12,3,'2024-05-03 12:15:51.849672'),
 (195,'96b3e4da-7f03-4114-a226-13b68a250f17','aeac1872-922b-44ef-9614-2f1638ca5545',3,'',12,3,'2024-05-03 12:15:51.858817'),
 (196,'8816163e-07ce-4f42-a001-7de08a09673d','c389ad60-5268-49d8-9bd3-e1b7d5b20d81',3,'',12,3,'2024-05-03 12:15:51.869312'),
 (197,'6d3d77a4-c6d8-4259-8ad4-0811c386c1be','c389ad60-5268-49d8-9bd3-e1b7d5b20d81',3,'',12,3,'2024-05-03 12:15:51.876995'),
 (198,'3aad09ea-0394-48c6-adac-9746f43b73a1','de915065-b426-44b4-a7de-e6e3bb7a352e',3,'',12,3,'2024-05-03 12:16:54.007345'),
 (199,'31900809-55df-4254-b8da-f504267e536e','de915065-b426-44b4-a7de-e6e3bb7a352e',3,'',12,3,'2024-05-03 12:16:54.014862'),
 (200,'93d87344-d9c7-40a6-bf93-06472d9634fe','495964e0-c288-45a3-89c1-71a13e4cd2eb',3,'',12,3,'2024-05-03 12:19:08.195337'),
 (201,'69520431-385d-4086-bbe9-3365f6c2ea4f','495964e0-c288-45a3-89c1-71a13e4cd2eb',3,'',12,3,'2024-05-03 12:19:08.203373'),
 (202,'f381877b-fde5-4711-bb89-72ab1193b4d5','09e27ca5-5110-4ff9-963e-62beee469b5e',3,'',12,3,'2024-05-03 16:28:47.694486'),
 (203,'ed57415e-6b6d-4f1f-b4e4-16ed38be4b9e','4ed89681-c676-48d7-9cef-4732b5d9e8c7',3,'',12,3,'2024-05-03 16:28:47.702531'),
 (204,'eca63899-756f-427e-b3e8-222d214ab29c','c082a34c-5b6c-4cf9-9ed7-1d2d80c1c72f',3,'',12,3,'2024-05-03 16:28:47.711358'),
 (205,'ec44cb84-e737-4b3a-b388-bb9fe94d8a92','4ed89681-c676-48d7-9cef-4732b5d9e8c7',3,'',12,3,'2024-05-03 16:28:47.721757'),
 (206,'e560ffbe-9af4-43f9-9500-2ef24bcadeee','bb07a9e0-9469-4ca4-bb2b-907a5e812595',3,'',12,3,'2024-05-03 16:28:47.731096'),
 (207,'dc046c57-55eb-4d49-9971-52ae94498f42','b3a2c13f-d304-4bdb-a73f-97b6713e280e',3,'',12,3,'2024-05-03 16:28:47.740847'),
 (208,'d4e74baa-bd6b-41f3-94ca-db8b57d71f80','bb07a9e0-9469-4ca4-bb2b-907a5e812595',3,'',12,3,'2024-05-03 16:28:47.751306'),
 (209,'ba2510da-f92e-4dcf-a35f-431bcc663461','09e27ca5-5110-4ff9-963e-62beee469b5e',3,'',12,3,'2024-05-03 16:28:47.760344'),
 (210,'b61b3a17-8cc7-465d-a996-80584e4fb448','bb07a9e0-9469-4ca4-bb2b-907a5e812595',3,'',12,3,'2024-05-03 16:28:47.769700'),
 (211,'9b50ff03-e3dd-4b39-aac5-8f9f0bc57e8e','2d12ac98-63e0-4335-b2da-3a86d98b0e50',3,'',12,3,'2024-05-03 16:28:47.780586'),
 (212,'8ee5c60f-ec25-4c1c-88ff-59b2e1780d3a','c082a34c-5b6c-4cf9-9ed7-1d2d80c1c72f',3,'',12,3,'2024-05-03 16:28:47.790314'),
 (213,'8e7ef891-2ff0-4347-a4f7-7d344c2de103','9c2673ce-f899-481d-9f5a-37f6a9dedd18',3,'',12,3,'2024-05-03 16:28:47.801448'),
 (214,'651b43e8-17a2-4a03-8f0a-66b149ceb9e5','99416a84-0b0a-4807-98b6-c244a54ce15e',3,'',12,3,'2024-05-03 16:28:47.809730'),
 (215,'591e20f2-6b0b-4bc0-b21b-aef701bf88df','bb07a9e0-9469-4ca4-bb2b-907a5e812595',3,'',12,3,'2024-05-03 16:28:47.820821'),
 (216,'47a55320-a69c-4cec-a2c6-019b5c4a729c','b3a2c13f-d304-4bdb-a73f-97b6713e280e',3,'',12,3,'2024-05-03 16:28:47.829417'),
 (217,'41f66db9-2c88-453a-a7c8-78cbab4beb5b','9c2673ce-f899-481d-9f5a-37f6a9dedd18',3,'',12,3,'2024-05-03 16:28:47.839374'),
 (218,'2b45279b-3f90-4204-826d-a531391387c9','9c2673ce-f899-481d-9f5a-37f6a9dedd18',3,'',12,3,'2024-05-03 16:28:47.847674'),
 (219,'2260b4c4-39fe-45ef-8e5c-45d42d60aae0','9c2673ce-f899-481d-9f5a-37f6a9dedd18',3,'',12,3,'2024-05-03 16:28:47.856345'),
 (220,'12ce2776-fd4f-4d1e-a05e-923c514c7c97','2d12ac98-63e0-4335-b2da-3a86d98b0e50',3,'',12,3,'2024-05-03 16:28:47.866830'),
 (221,'c6c13c12-2c9e-4da8-a79a-bfa3e16906f3','71b95f38-a410-4fcf-8302-232da99bc5a4',3,'',12,3,'2024-05-03 16:34:43.147393'),
 (222,'bbf26bdd-6244-47bb-9abb-f9c762f445eb','Tesst',3,'',14,3,'2024-05-05 04:58:19.481974'),
 (223,'fb40ca24-6ea9-4edc-b4c7-e62fb73e2233','aaaaa',3,'',14,3,'2024-05-05 04:59:29.424172'),
 (224,'69551344-fc09-4726-86c0-015637c5e76f','Tesst',3,'',14,3,'2024-05-05 04:59:29.431701'),
 (225,'40a39134-7e1c-4750-b6bd-c1b1fc719a77','Tesst',3,'',14,3,'2024-05-05 04:59:29.440283');
INSERT INTO "django_content_type" VALUES (1,'admin','logentry'),
 (2,'auth','permission'),
 (3,'auth','group'),
 (4,'auth','user'),
 (5,'contenttypes','contenttype'),
 (6,'sessions','session'),
 (7,'restaurant','customer'),
 (8,'restaurant','mytable'),
 (9,'restaurant','restaurant'),
 (10,'restaurant','translation'),
 (11,'restaurant','user'),
 (12,'restaurant','booking'),
 (13,'restaurant','menu'),
 (14,'restaurant','food'),
 (15,'restaurant','category'),
 (16,'restaurant','foodsub'),
 (17,'restaurant','bookingdetail'),
 (18,'restaurant','categorysub');
INSERT INTO "auth_permission" VALUES (1,1,'add_logentry','Can add log entry'),
 (2,1,'change_logentry','Can change log entry'),
 (3,1,'delete_logentry','Can delete log entry'),
 (4,1,'view_logentry','Can view log entry'),
 (5,2,'add_permission','Can add permission'),
 (6,2,'change_permission','Can change permission'),
 (7,2,'delete_permission','Can delete permission'),
 (8,2,'view_permission','Can view permission'),
 (9,3,'add_group','Can add group'),
 (10,3,'change_group','Can change group'),
 (11,3,'delete_group','Can delete group'),
 (12,3,'view_group','Can view group'),
 (13,4,'add_user','Can add user'),
 (14,4,'change_user','Can change user'),
 (15,4,'delete_user','Can delete user'),
 (16,4,'view_user','Can view user'),
 (17,5,'add_contenttype','Can add content type'),
 (18,5,'change_contenttype','Can change content type'),
 (19,5,'delete_contenttype','Can delete content type'),
 (20,5,'view_contenttype','Can view content type'),
 (21,6,'add_session','Can add session'),
 (22,6,'change_session','Can change session'),
 (23,6,'delete_session','Can delete session'),
 (24,6,'view_session','Can view session'),
 (25,7,'add_customer','Can add customer'),
 (26,7,'change_customer','Can change customer'),
 (27,7,'delete_customer','Can delete customer'),
 (28,7,'view_customer','Can view customer'),
 (29,8,'add_mytable','Can add my table'),
 (30,8,'change_mytable','Can change my table'),
 (31,8,'delete_mytable','Can delete my table'),
 (32,8,'view_mytable','Can view my table'),
 (33,9,'add_restaurant','Can add restaurant'),
 (34,9,'change_restaurant','Can change restaurant'),
 (35,9,'delete_restaurant','Can delete restaurant'),
 (36,9,'view_restaurant','Can view restaurant'),
 (37,10,'add_translation','Can add translation'),
 (38,10,'change_translation','Can change translation'),
 (39,10,'delete_translation','Can delete translation'),
 (40,10,'view_translation','Can view translation'),
 (41,11,'add_user','Can add user'),
 (42,11,'change_user','Can change user'),
 (43,11,'delete_user','Can delete user'),
 (44,11,'view_user','Can view user'),
 (45,12,'add_booking','Can add booking'),
 (46,12,'change_booking','Can change booking'),
 (47,12,'delete_booking','Can delete booking'),
 (48,12,'view_booking','Can view booking'),
 (49,13,'add_menu','Can add menu'),
 (50,13,'change_menu','Can change menu'),
 (51,13,'delete_menu','Can delete menu'),
 (52,13,'view_menu','Can view menu'),
 (53,14,'add_food','Can add food'),
 (54,14,'change_food','Can change food'),
 (55,14,'delete_food','Can delete food'),
 (56,14,'view_food','Can view food'),
 (57,15,'add_category','Can add category'),
 (58,15,'change_category','Can change category'),
 (59,15,'delete_category','Can delete category'),
 (60,15,'view_category','Can view category'),
 (61,16,'add_foodsub','Can add food sub'),
 (62,16,'change_foodsub','Can change food sub'),
 (63,16,'delete_foodsub','Can delete food sub'),
 (64,16,'view_foodsub','Can view food sub'),
 (65,17,'add_bookingdetail','Can add booking detail'),
 (66,17,'change_bookingdetail','Can change booking detail'),
 (67,17,'delete_bookingdetail','Can delete booking detail'),
 (68,17,'view_bookingdetail','Can view booking detail'),
 (69,18,'add_categorysub','Can add category sub'),
 (70,18,'change_categorysub','Can change category sub'),
 (71,18,'delete_categorysub','Can delete category sub'),
 (72,18,'view_categorysub','Can view category sub');
INSERT INTO "auth_user" VALUES (2,'pbkdf2_sha256$720000$OpO2jQwx18HxLU5sXvS9vK$TUoDp+S8PutDTjec8d/WB1B1xR1ASO+fCHImyNWi3PM=','2024-05-16 12:43:26.935256',0,'demo','Firstimer','',0,1,'2024-04-28 09:27:04.500187','Alice'),
 (3,'pbkdf2_sha256$720000$rleV8DulHaDkaFFGewAlNi$IKemQsw9+axVOKpBiFWxjZgPV3hlpmmSro7lzo/Sscw=','2024-05-17 01:05:05.986379',1,'admin','','admin@gmail.com',1,1,'2024-04-28 09:29:56.281454','');
INSERT INTO "django_session" VALUES ('m0vn0m3wimbjuo3nobuiz6c5be3qw65n','.eJxVjMsOwiAQRf-FtSHA8HTp3m8gMINSNZCUdmX8d9ukC92ec-59s5jWpcZ1lDlOxM4M2OmX5YTP0nZBj9TunWNvyzxlvif8sINfO5XX5Wj_DmoadVsXSFYbA6QIVbbu5kiYbFWQ2qNGqzcQMgXhRADnQSjpi0WSaDQoldjnC9MWNxc:1s1HLo:yFme5ZalEmbT-kjEYLJCNDUwgT1dZ5lwTCc1bOJcYZQ','2024-05-13 03:06:44.562484'),
 ('opfp3akp6vvjwmgfb3sm50g45qe6vzn9','.eJxVjDsOwjAQBe_iGlna-E9JzxmsdXaNA8iW4qSKuDuylALaNzPvEBH3rcS98xoXElehxOV3Szi_uA5AT6yPJudWt3VJcijypF3eG_H7drp_BwV7GTWBZ20CsQdDbgJLABZYB_A6B4ezJZc9TVkltCqx5UCKMjgPyoATny_hwje_:1s20TU:hwUBB934o_l7HNpZ_Gqq4nqLkFMablVwHzswGmzKPXI','2024-05-15 03:17:40.429533'),
 ('wiz0gtz2qte0p7bsyr8tztjpzj7jgk8u','.eJxVjEEOwiAQRe_C2hBailNcuu8ZyAwzSNXQpLQr492VpAvd_vfef6mA-5bDXmUNM6uLsur0uxHGh5QG-I7ltui4lG2dSTdFH7TqaWF5Xg_37yBjza3uTUTwYmyKZ4_C4CwYFvbEfnQsnofuKxhPNtmxpwE4JmcMACamTr0_Aa84ow:1s29s3:FE65uYF-WsKxRk1JNT6plGjtS98UPH3KZM8WQDSYfEQ','2024-05-15 13:19:39.535853'),
 ('tp94mejy3bpp2x1t8ofw9ouxfiz8bspb','.eJxVjEEOwiAQRe_C2hBailNcuu8ZyAwzSNXQpLQr492VpAvd_vfef6mA-5bDXmUNM6uLsur0uxHGh5QG-I7ltui4lG2dSTdFH7TqaWF5Xg_37yBjza3uTUTwYmyKZ4_C4CwYFvbEfnQsnofuKxhPNtmxpwE4JmcMACamTr0_Aa84ow:1s2tmY:_InIvLvTSr-4OF0YdpAqOZHfRzzW9n5mASxrx-vGzgQ','2024-05-17 14:21:02.105869'),
 ('o34abih5mddlu7peqf7n7876pw63tfsx','.eJxVjEEOwiAQRe_C2hBailNcuu8ZyAwzSNXQpLQr492VpAvd_vfef6mA-5bDXmUNM6uLsur0uxHGh5QG-I7ltui4lG2dSTdFH7TqaWF5Xg_37yBjza3uTUTwYmyKZ4_C4CwYFvbEfnQsnofuKxhPNtmxpwE4JmcMACamTr0_Aa84ow:1s3duS:Xc70jD4W1cvd9DuScrtN_gN26Sh1sYNVlNOchMjhJO4','2024-05-19 15:36:16.172766'),
 ('rtgossvr43a7lbfx7sckhno5gbkxm95b','.eJxVjEEOwiAQRe_C2hBailNcuu8ZyAwzSNXQpLQr492VpAvd_vfef6mA-5bDXmUNM6uLsur0uxHGh5QG-I7ltui4lG2dSTdFH7TqaWF5Xg_37yBjza3uTUTwYmyKZ4_C4CwYFvbEfnQsnofuKxhPNtmxpwE4JmcMACamTr0_Aa84ow:1s3pfu:YrNNJ76E3QssWr0RXU25JHloycNjX3teMAHpQLTA2Fw','2024-05-20 04:10:02.383111'),
 ('hqvc7zl422im1x4eapt7zgzhauo2ova1','.eJxVjEEOwiAQRe_C2hCgjGVcuu8ZyNAZbNVAUtqV8e7apAvd_vfef6lI2zrFrckSZ1YX5dTpd0s0PqTsgO9UblWPtazLnPSu6IM2PVSW5_Vw_w4matO3NkgCEKwYh3QGFgjkufOGAW123GPKgCF4m_uEnAyCoBuN6SFxZ716fwDS-DdV:1s6AIT:5fhc5WWPLwT4nDuLte-rCiHTUr_5ca_JFsbTgzk6mKk','2024-05-26 14:35:29.550928'),
 ('tp198pwupq05z7cj643m2iyy3qnr6ayx','.eJxVjEEOwiAQRe_C2hBailNcuu8ZyAwzSNXQpLQr492VpAvd_vfef6mA-5bDXmUNM6uLsur0uxHGh5QG-I7ltui4lG2dSTdFH7TqaWF5Xg_37yBjza3uTUTwYmyKZ4_C4CwYFvbEfnQsnofuKxhPNtmxpwE4JmcMACamTr0_Aa84ow:1s7m1y:8ZzG0QSK9gDwqbgH9HMXB5YvFrAm-V-lUDF29CNOPrI','2024-05-31 01:05:06.115120');
INSERT INTO "restaurant_restaurant" VALUES ('Viet An','73-75 Skene Street, Aberdeen, AB10 1QD','123456789','info@viet-an.co.uk','                                        Flavors of the East, Served with Passion
                  
                  
                  
                  ','5PM - 22PM','b8ed477ae1824394b6e788d114d3e03c');
INSERT INTO "restaurant_translation" VALUES ('English','En','English','ea24d0e4140048c0a1651fe2a96272a0'),
 ('Vietnamese','Vi','Vietnamese','d69921ca8e6d4610aa389eea126c8cb6');
INSERT INTO "restaurant_bookingdetail" VALUES ('de0e6d9f33244562a606ddf0b079527e',3,6.95,NULL,NULL,NULL,'946bcf8c3d7b4dae8964f67283eee2de','102fdc7090244b75a9570f341b01ec2e',NULL),
 ('378dd5ccf9044e8d9406c9a70bff4139',3,6.95,NULL,NULL,NULL,'d208862056b84a9c88a7d445445286de','102fdc7090244b75a9570f341b01ec2e',NULL),
 ('161aeb41a9584b3bb6c305f01e9c0840',2,8.95,NULL,NULL,NULL,'f2e3df2cfbaf41efaeffc3ea6ea1d181','f32328ab4c374932a211b964dd87e370',NULL),
 ('e9f985e01e4b4c07b100567734e85055',2,8.95,NULL,NULL,NULL,'f2e3df2cfbaf41efaeffc3ea6ea1d181','6a005aa96ad042bebc4f9bb1f88b5688',NULL),
 ('41435c7cb0fd41dc870f6b4568aaae38',1,8.95,NULL,NULL,NULL,'a7d6f17fe561429d835befa92978e4c5','523eb82896774f229d11a6a7b75d12fc',NULL),
 ('386dc516363247709135bb3e18b42337',1,6.95,NULL,NULL,NULL,'7ec06b3acff14d61a954ff79e6e913fe','102fdc7090244b75a9570f341b01ec2e',NULL),
 ('c06e6b1d33944978a5b1b744fabd1a0b',1,7.25,NULL,NULL,NULL,'7ec06b3acff14d61a954ff79e6e913fe','26405bc1e42544e5a511928181d5800e',NULL);
INSERT INTO "restaurant_category" VALUES ('c7decc5c8a1c4b3d8f442fe7796b3bb8','SMALL BITES','79aca22c66cd4964812ae9c6af38098b','filter-small-bites','ea24d0e4140048c0a1651fe2a96272a0'),
 ('4419c1073f23469fad24d6b0ddbac4cb','MAINS','79aca22c66cd4964812ae9c6af38098b','filter-mains','ea24d0e4140048c0a1651fe2a96272a0'),
 ('767167f57ecd484fabf79b5ca23f2ed3','DESSERTS','79aca22c66cd4964812ae9c6af38098b','filter-desserts','ea24d0e4140048c0a1651fe2a96272a0');
INSERT INTO "restaurant_categorysub" VALUES ('7526d1754cf54edeb568eaa3458dfa27','RICE','4419c1073f23469fad24d6b0ddbac4cb','ea24d0e4140048c0a1651fe2a96272a0'),
 ('ab5c5b89d5064c44aaadf171b3b3ac2d','RICE NOODLE SOUP','4419c1073f23469fad24d6b0ddbac4cb','ea24d0e4140048c0a1651fe2a96272a0'),
 ('8d6222df6a5c44b1b929cf04ea98a983','VERMICELLI NOODLES','4419c1073f23469fad24d6b0ddbac4cb','ea24d0e4140048c0a1651fe2a96272a0');
INSERT INTO "restaurant_customer" VALUES ('14151429a459442dad8e11aac913114c','namdatuoc22@gmail.com','2344566789','f113bd2b0b1e40afb4c0dac15718e6b2'),
 ('541c61577b44438ab84f7525d2e54734','admin@gmail.com','0763671496','fdd9d59ede8645878951e088eb62ac84'),
 ('db8c98ad9ac44fbe9a7c0e81ae3188b5','chaudanghuy@gmail.com','1233456789','2db25700e7264e70b01f499449beb392'),
 ('dad8d309444e4b8d90f1cc823a31a808','egage@aaa','0768567579','ec0d5395cc2e495bbb12779a07b583c2'),
 ('dc8c1762e98f427191073f5e4a068a57','sss@gmail.com','0763671496','c65c0fb1cf984aa1a1b8af783e7b52c9'),
 ('7810cafcede74aaeb69a145b0c4ad0ef','chaudanghuy6789@gmail.com','1233456789','f9f1b1dd3448434a83ff13bf9b59a3d8'),
 ('f399a8b3cf1a4ca88bf2a08994472153','admin22@gmail.com','1233456789','efa67ee42ede4e46b20451814c770bef'),
 ('c79e6157928045dfbd4142bd97f7262c','admin123@gmail.com','1233456789','5fa5656759184d6dadd301224b99a3e7'),
 ('02bb7c746c374788b47ca6410906dbb6','tintucgac8@gmail.com','0768567579','e36373c844504b7f90650d5fa7523407'),
 ('617eaf47bea74d3098be836bd683be58','admin11@gmail.com','1233456789','44c8f654e73046ca85bba08c5d16846a'),
 ('0371c4fbd30b472eb7074c592bee376a','aaaaaaaaaaaaaaaa@gg.com','1233456789','c971d94db1d441c0b76d0a3f291b17d3'),
 ('89bc27f08b134c99899385df4c1cd5d1','test@gmail.com','1233456789','928bc5f0e857488f8b6298d7b295c53d'),
 ('a57e310fdbcb4336a2741edc5b4b93ee','','1222223333','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('fe8833d5ea394cb9ab17ec5f7c8c1d51','aaa','1223332333331','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('acf88a299cdb4f2eb3dda98e09b67f66','No address provided','3252454256446','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('86e72e0641344b04ba96a46e677e64be','No address provided','11111','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('1897a08b447147f4b5a82b5a73507584','aaa','12235665776','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('9fb888adabdf4846959b3e20819bf8f6','aaaa','113532254264','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('f647c66d4c4c4859bcbfa21e61df8e98','No address provided','89698698698','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('3e9d719a8db9419c8b0bcf7bb8d47e9b','No address provided','23333333333333','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('5e80ca32080943acb97f5e3d4bf30843','No address provided','546464','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('b4799020aef341c282294b615e2e59d3','aaa','4509785407845','bba07d4ad39a4bdb8fa8ba1eb8d6a589'),
 ('e7f6c58527ad4043b3ae6b8bf4df08f6','No address provided','1111111111','0413ff1c2b69480886cefd41eceec037'),
 ('3f403248023246eaa3ac3de50835e6bf','pickup-order','336646464646464','c2e3a6c563cf4025b119edcabd2cfe71'),
 ('e2d782721ffc444ca67514e8c36b0231','pickup-order','01224 356826','f9f1b1dd3448434a83ff13bf9b59a3d8'),
 ('5c0ca71e92534d7d885c358072024ba5','pickup-order','0768567579','2db25700e7264e70b01f499449beb392'),
 ('5409c732c47046a9b8246668ab82fe9b','test-booking6789@gmail.com','1233456789','a1ef93fb3798489fbcb76ca4e70d5c93'),
 ('4c91ac24a7af429aacc703065734d373','pickup-order','1233456789','fdd9d59ede8645878951e088eb62ac84');
INSERT INTO "restaurant_food" VALUES ('102fdc7090244b75a9570f341b01ec2e','Summer Rolls','Vietnamese flavours wrapped in soft rice paper. Served with a choice of peanut sauce or nuoc cham. Choose from:
A - Prawns 
B - Pork
C - Prawns & Pork',6.95,'food/summerrolls.jpg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('fde3f89f20ed4e289f8fc3d17d2a1380','Vegetarian Summer Rolls VG','Vietnamese flavours wrapped in soft rice paper',6.45,'food/photo1714695546.jpeg','unavailable','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('b664c1b787e340ad8d57387fdb730d8b','Square Crab Spring Rolls','Square crab spring rolls with prawn, crab and chicken. Served on lettuce and herbs ready to wrap and dip',7.45,'food/squarecrabspringrolls.jpg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('26405bc1e42544e5a511928181d5800e','Crispy Spring Rolls','Deep fried spring rolls with pork, prawn and chicken. Served on lettuce and herbs ready to wrap and dip',7.25,'food/csripyspringrolls.jpg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('989138e608324c299994967b9e2d31dd','Vegetarian Spring Rolls VG','Crispy vegetarian spring rolls served on a bed of lettuce and herbs ready to wrap and dip in our homemade
vegetarian nuoc cham sauce',6.45,'food/csripyspringrolls_EBEMz2L.jpg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('3d35deab131e4d1988d3a509b0088605','Prawn and Sweet Potato Fritters','Crispy prawn fritters served with lettuce and herbs ready to wrap and dip',7.95,'food/prawnandsweetpotato.jpg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('9573a57380ca4c6a8a8c878042546c78','Salt &  Pepper Chicken Wings','Flash pan-fried chicken wings, served with salt, pepper and lime dip',7.25,'food/photo1714614283.jpeg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('85d224f7f06a425cbdf765a5f3afda6b','Papaya Salad VG','Crunchy green papaya salad with crushed peanuts. Choose from:

A - Vegetarian Papaya Salad
B - Chicken Papaya Salad
C - Prawn Papaya Salad',9.45,'food/papayasallad.jpg','available','c7decc5c8a1c4b3d8f442fe7796b3bb8',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('25a546cd2e444ff588e9efaf2a90d898','Vietnamese Baguette','Authentic Vietnamese baguette filled with pate, pickled veg and fresh herbs',8.95,'food/vietnamesebaguette.jpg','available','4419c1073f23469fad24d6b0ddbac4cb',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('523eb82896774f229d11a6a7b75d12fc','Chargrilled Pork Baguette','Traditional Vietnamese baguette with lemongrass chargrilled pork',8.95,'food/chargrilledporkbaguette.jpg','available','4419c1073f23469fad24d6b0ddbac4cb',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('c4e39ed077df4100845ff6f20d3c6e4a','Grilled Chicken Baguette','Tradition Vietnamese baguette with chicken',8.95,'food/grilledchickenbaguette.jpg','available','4419c1073f23469fad24d6b0ddbac4cb',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('f32328ab4c374932a211b964dd87e370','Vietnamese Pork Sausage and Fried Egg Baguette','Vietnamese style pork roll with fried egg',8.95,'food/vietnameseporksausageandfriedegg.jpg','available','4419c1073f23469fad24d6b0ddbac4cb',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('6a005aa96ad042bebc4f9bb1f88b5688','Steak Baguette','Traditional Vietnamese beef steak baguette',8.95,'food/vietnamesesteakbaguette.jpg','available','4419c1073f23469fad24d6b0ddbac4cb',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('259d21ae26304b62b933a115bf95e598','Vegetarian Baguette','Vietnamese baguette with fried tofu',8.75,'food/vegetarianbaguette.jpg','available','4419c1073f23469fad24d6b0ddbac4cb',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('9f6fc5cee3574a6790c808827d6c7677','Ginger Chicken Rice','Whole boneless chicken leg with boiled rice',12.75,'food/photo1714614328.jpeg','available','4419c1073f23469fad24d6b0ddbac4cb','7526d1754cf54edeb568eaa3458dfa27','ea24d0e4140048c0a1651fe2a96272a0'),
 ('ebf18027e3b444239ebcba84949bf019','Chargrilled Pork Rice','Lemongrass chargrilled pork with boiled rice',12.75,'food/chargrilledporkrice.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','7526d1754cf54edeb568eaa3458dfa27','ea24d0e4140048c0a1651fe2a96272a0'),
 ('15311de441774b3daa655e91335ce106','Vegetarian Pho VG','Fragrant vegetable broth prepared daily',12.25,'food/photo1714614297.jpeg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('5d8e5d4e292e4be1a09fe9341dd94273','Beef Brisket Pho','Tender beef brisket slow cooked in our 24-hour beef broth',12.25,'food/beefbrisketnoodlesoup.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('8233fe77a66b42f588ea881ef1c1bd1f','Medium Rare Steak Soup','Flash fried steak',12.95,'food/mediumrraresteaksoup.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('01f679d2f933480cbc709e036a963f5f','Short Beef Rib Pho','Tender short beef rib slow cooked in our 24-hour beef broth',12.95,'food/shortbeefribsoup.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('d8d3b2a4f3b045c68e1e0a84b4abadd8','Oxtail and Rib Soup','Tender pieces of oxtail and short beef rib slow cooked in our 24-hour beef broth
Choice of oxtail on the bone or off the bone',13.95,'food/oxtailandribsoup.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('54cdc53a9a7e47a99320658b452a2888','Beef Pho Combo','Flank, steak, oxtail and rib',13.95,'food/beefcombosoup.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('d9daef939fe543bea89f0c351087ad5d','Chicken Pho','Light yet flavourful chicken broth slow cooked
with a combination of herbs and spices. Choose from:
A - Leg
B - Breast 
C - Leg & Breast',13.95,'food/chickphosoup.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','ab5c5b89d5064c44aaadf171b3b3ac2d','ea24d0e4140048c0a1651fe2a96272a0'),
 ('34922cdf82eb4333bce26822e8cc4fc6','Chargrilled Pork Vermicelli','Lemongrass chargrilled pork',12.75,'food/chargrilledporkvermi.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','8d6222df6a5c44b1b929cf04ea98a983','ea24d0e4140048c0a1651fe2a96272a0'),
 ('6a216e2e614544299f1890445e463876','Crispy Spring Rolls Vermicelli','Deep fried pork and prawn spring rolls',12.75,'food/crispyspringrollvermi.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','8d6222df6a5c44b1b929cf04ea98a983','ea24d0e4140048c0a1651fe2a96272a0'),
 ('e22f2421baa24bd5a61fd036b1b7eeb4','Square Crab Spring Rolls Vermicelli','Crispy square spring rolls with prawns, chicken and crab',12.95,'food/photo1714614311.jpeg','available','4419c1073f23469fad24d6b0ddbac4cb','8d6222df6a5c44b1b929cf04ea98a983','ea24d0e4140048c0a1651fe2a96272a0'),
 ('f83a024a9c414bdaa6a094f7bb86f469','Vegetarian Spring Rolls','Crispy vegetarian spring rolls',12.25,'food/vegetarianspringrollvermi.jpg','available','4419c1073f23469fad24d6b0ddbac4cb','8d6222df6a5c44b1b929cf04ea98a983','ea24d0e4140048c0a1651fe2a96272a0'),
 ('881c7586cba24ee3bf2de2c0822afd87','Vanilla Ice Cream','3 scoops of Vanilla ice cream',3.95,'food/vanillaicecream.jpg','available','767167f57ecd484fabf79b5ca23f2ed3',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('1a6697405f3b4a89a05d4f2b81445d8c','Vietnamese Fruit Cocktail','A refreshing Vietnamese dessert made of fruits, jellies and coconut milk',6.95,'food/vietnamesefruitcocktail.jpg','available','767167f57ecd484fabf79b5ca23f2ed3',NULL,'ea24d0e4140048c0a1651fe2a96272a0'),
 ('026f8139488747168a8f4db1acc59e98','Banana Fritters','Served with vanilla ice cream',5.95,'food/IMG_6612-scaled.jpeg','unavailable','767167f57ecd484fabf79b5ca23f2ed3',NULL,'ea24d0e4140048c0a1651fe2a96272a0');
INSERT INTO "restaurant_foodsub" VALUES ('44125486a06a448ebb250ee56be98f57','Chargrilled Pork or Crispy Spring Roll',1.95,'food/extrachargrilledPorkOrCrispySPringRoll.jpg','available','f83a024a9c414bdaa6a094f7bb86f469','ea24d0e4140048c0a1651fe2a96272a0'),
 ('4659c2c438ec415ab3876107baef2094','Square Crab Spring Roll',2.25,'food/extrasquarecrabspringroll.jpg','available','f83a024a9c414bdaa6a094f7bb86f469','ea24d0e4140048c0a1651fe2a96272a0'),
 ('5c8229e9f16f4d0390b7ce984316f377','Vegetarian Spring Rolls',1.75,'food/extravegetarianspringrolls.jpg','available','f83a024a9c414bdaa6a094f7bb86f469','ea24d0e4140048c0a1651fe2a96272a0');
INSERT INTO "restaurant_menu" VALUES ('79aca22c66cd4964812ae9c6af38098b','Menu','Check Our Tasty Menu','b8ed477ae1824394b6e788d114d3e03c');
INSERT INTO "restaurant_mytable" VALUES ('94c94cba1a944496a0bede5e5ce77ac9',7,'available','b8ed477ae1824394b6e788d114d3e03c','1'),
 ('a66512d538904367bca39f3442ca3675',7,'available','b8ed477ae1824394b6e788d114d3e03c','2'),
 ('e7185c20cd9b44f3871e95745f420a92',7,'available','b8ed477ae1824394b6e788d114d3e03c','3'),
 ('77e8a4bb70cd49b6896f5b4bfe6011cd',7,'available','b8ed477ae1824394b6e788d114d3e03c','4'),
 ('dc12d87fa319413c9ede14a368828c25',7,'available','b8ed477ae1824394b6e788d114d3e03c','5');
INSERT INTO "restaurant_booking" VALUES ('be0dbf65b8d54244a86bd1b32f70136f','2024-05-07','11:12',1,'Pending','pickup-order','6015acd6-a450-4f6e-bd96-ebeb967e7084','23:59:59',0,'e7f6c58527ad4043b3ae6b8bf4df08f6','77e8a4bb70cd49b6896f5b4bfe6011cd',60,0),
 ('946bcf8c3d7b4dae8964f67283eee2de','2024-05-07','11:12',1,'Pending','pickup-order','c19bd1f9-b7ea-4a7b-b600-1aaa158bdbd6','23:59:59',0,'e7f6c58527ad4043b3ae6b8bf4df08f6','77e8a4bb70cd49b6896f5b4bfe6011cd',60,20.85),
 ('d208862056b84a9c88a7d445445286de','2024-05-16','18:00',1,'Pending','wetewtewtet','c68aaea7-1eb5-4121-b395-e7857a00de4e','23:59:59',0,'3f403248023246eaa3ac3de50835e6bf','77e8a4bb70cd49b6896f5b4bfe6011cd',30,20.85),
 ('f2e3df2cfbaf41efaeffc3ea6ea1d181','2024-05-23','17:00',1,'Pending','No special request','72d27b8f-bc19-4fbc-a7d0-d5d044bdfccb','23:59:59',0,'e2d782721ffc444ca67514e8c36b0231','77e8a4bb70cd49b6896f5b4bfe6011cd',30,35.8),
 ('a7d6f17fe561429d835befa92978e4c5','2024-05-17','18:00',1,'Pending','grgrgrgrhrhr','f4ef22c3-2f5b-48b9-b103-5609c96f1e8f','23:59:59',0,'5c0ca71e92534d7d885c358072024ba5','77e8a4bb70cd49b6896f5b4bfe6011cd',30,8.95),
 ('c46ff89fcc254e188d385670c077b009','2024-05-18','17:30',5,'pending','aaa','6b82e45c-f9d7-4bc9-a6ad-61e08a1ccd7a','23:59:59',0,'7810cafcede74aaeb69a145b0c4ad0ef','94c94cba1a944496a0bede5e5ce77ac9',120,0),
 ('f2ab9199e8834951a12f9704928cb34d','2024-05-17','19:00',9,'pending','None','d2454259-ba15-4e7f-a95f-c9322f4d2453','23:59:59',0,'5409c732c47046a9b8246668ab82fe9b','94c94cba1a944496a0bede5e5ce77ac9',150,0),
 ('41e3ca68f6fc4c358bc6037c9e1e979a','2024-05-17','19:00',9,'pending','None','d2454259-ba15-4e7f-a95f-c9322f4d2453','23:59:59',0,'5409c732c47046a9b8246668ab82fe9b','a66512d538904367bca39f3442ca3675',150,0),
 ('7ec06b3acff14d61a954ff79e6e913fe','2024-05-17','18:00',1,'Pending','aaa','202350e5-7c31-4b6f-837f-c85d000110d7','23:59:59',0,'4c91ac24a7af429aacc703065734d373','77e8a4bb70cd49b6896f5b4bfe6011cd',30,14.2);
INSERT INTO "restaurant_user" VALUES ('f113bd2b0b1e40afb4c0dac15718e6b2','namdatuoc22@gmail.com','123','namdatuoc22@gmail.com',''),
 ('fdd9d59ede8645878951e088eb62ac84','admin@gmail.com','123','admin@gmail.com','ahihi'),
 ('2db25700e7264e70b01f499449beb392','chaudanghuy@gmail.com','123','chaudanghuy@gmail.com','Ronaldo'),
 ('ec0d5395cc2e495bbb12779a07b583c2','egage@aaa','123','egage@aaa','sagag'),
 ('c65c0fb1cf984aa1a1b8af783e7b52c9','sss@gmail.com','123','sss@gmail.com','sss'),
 ('f9f1b1dd3448434a83ff13bf9b59a3d8','chaudanghuy6789@gmail.com','123','chaudanghuy6789@gmail.com','Test'),
 ('efa67ee42ede4e46b20451814c770bef','admin22@gmail.com','123','admin22@gmail.com','aaaa'),
 ('5fa5656759184d6dadd301224b99a3e7','admin123@gmail.com','123','admin123@gmail.com','Alice'),
 ('e36373c844504b7f90650d5fa7523407','tintucgac8@gmail.com','123','tintucgac8@gmail.com','Ahihi'),
 ('44c8f654e73046ca85bba08c5d16846a','admin11@gmail.com','123','admin11@gmail.com','sss'),
 ('c971d94db1d441c0b76d0a3f291b17d3','aaaaaaaaaaaaaaaa@gg.com','123','aaaaaaaaaaaaaaaa@gg.com','aaaa'),
 ('928bc5f0e857488f8b6298d7b295c53d','test@gmail.com','123','test@gmail.com','TEst'),
 ('bba07d4ad39a4bdb8fa8ba1eb8d6a589','guest','123','aaa@g.com',''),
 ('0413ff1c2b69480886cefd41eceec037','hlhlhalke@gg.com','123','hlhlhalke@gg.com',''),
 ('c2e3a6c563cf4025b119edcabd2cfe71','anhaa@gmail.com','123','anhaa@gmail.com',''),
 ('a1ef93fb3798489fbcb76ca4e70d5c93','test-booking6789@gmail.com','123','test-booking6789@gmail.com','Test Booking');
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "restaurant_bookingdetail_booking_id_0c5a5d8d" ON "restaurant_bookingdetail" (
	"booking_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_bookingdetail_food_id_2b612a01" ON "restaurant_bookingdetail" (
	"food_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_bookingdetail_food_sub_id_cfe85be6" ON "restaurant_bookingdetail" (
	"food_sub_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_category_menu_id_id_b3fca9a3" ON "restaurant_category" (
	"menu_id_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_category_translation_id_66ed3f6c" ON "restaurant_category" (
	"translation_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_categorysub_category_id_id_f1c2c91f" ON "restaurant_categorysub" (
	"category_id_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_categorysub_translation_id_e72b9d1b" ON "restaurant_categorysub" (
	"translation_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_customer_user_id_64a310c1" ON "restaurant_customer" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_food_category_id_ed12e3ae" ON "restaurant_food" (
	"category_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_food_category_sub_id_573de62d" ON "restaurant_food" (
	"category_sub_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_food_translation_id_4ccf5c72" ON "restaurant_food" (
	"translation_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_foodsub_food_id_40024d0e" ON "restaurant_foodsub" (
	"food_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_foodsub_translation_id_e15ccf75" ON "restaurant_foodsub" (
	"translation_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_menu_restaurant_id_af786758" ON "restaurant_menu" (
	"restaurant_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_mytable_restaurant_id_59a3cc11" ON "restaurant_mytable" (
	"restaurant_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_booking_customer_id_1d94ea64" ON "restaurant_booking" (
	"customer_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_booking_table_id_f910fa1b" ON "restaurant_booking" (
	"table_id"
);
COMMIT;
