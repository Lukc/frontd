-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: altideal1 | type: DATABASE --
-- -- DROP DATABASE IF EXISTS altideal1;
-- CREATE DATABASE altideal1
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'fr_FR.UTF-8'
-- 	LC_CTYPE = 'fr_FR.UTF-8'
-- 	TABLESPACE = pg_default
-- 	OWNER = postgres;
-- -- ddl-end --
-- 

-- object: public.update_modified_column | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.update_modified_column() CASCADE;
CREATE FUNCTION public.update_modified_column ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$
BEGIN
   IF row(NEW.*) IS DISTINCT FROM row(OLD.*) THEN
      NEW.date_row_modified = now(); 
      RETURN NEW;
   ELSE
      RETURN OLD;
   END IF;
END;

$$;
-- ddl-end --
ALTER FUNCTION public.update_modified_column() OWNER TO postgres;
-- ddl-end --

-- object: public.brand_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.brand_id_seq CASCADE;
CREATE SEQUENCE public.brand_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.brand_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.brands | type: TABLE --
-- DROP TABLE IF EXISTS public.brands CASCADE;
CREATE TABLE public.brands (
	id serial NOT NULL,
	brand_name text,
	date_row_created timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
	date_row_modified timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
	uuid uuid,
	CONSTRAINT brands_pk PRIMARY KEY (id),
	CONSTRAINT brands_uuid_unique UNIQUE (uuid)

);
-- ddl-end --
ALTER TABLE public.brands OWNER TO postgres;
-- ddl-end --

-- object: public.deal_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.deal_id_seq CASCADE;
CREATE SEQUENCE public.deal_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.deal_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.deals | type: TABLE --
-- DROP TABLE IF EXISTS public.deals CASCADE;
CREATE TABLE public.deals (
	id bigserial NOT NULL,
	uuid uuid NOT NULL,
	title text NOT NULL,
	description text,
	link_to_detail_deal text,
	date_start timestamp with time zone,
	date_end timestamp with time zone,
	deal_rating smallint NOT NULL DEFAULT 0,
	date_row_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
	date_row_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
	is_free bool DEFAULT false,
	code_promo text,
	current_price integer,
	original_price integer,
	link_database_user_id bigint NOT NULL,
	dealer_id integer,
	deal_target_counsumer_country smallint,
	category_id smallint,
	product_id bigint,
	brand_id integer,
	CONSTRAINT deal_pkey PRIMARY KEY (id),
	CONSTRAINT no_double_uuid_deals UNIQUE (uuid)

);
-- ddl-end --
ALTER TABLE public.deals OWNER TO postgres;
-- ddl-end --

-- object: public.dealers_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.dealers_id_seq CASCADE;
CREATE SEQUENCE public.dealers_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.dealers_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.dealers | type: TABLE --
-- DROP TABLE IF EXISTS public.dealers CASCADE;
CREATE TABLE public.dealers (
	id serial NOT NULL,
	name text NOT NULL,
	website text,
	date_row_created timestamp with time zone,
	date_row_modified timestamp with time zone,
	"public modification locked" bool,
	dealer_partership_type_id smallint,
	uuid uuid,
	CONSTRAINT dealers_pkey PRIMARY KEY (id),
	CONSTRAINT dealers_uuid_unique UNIQUE (uuid)

);
-- ddl-end --
ALTER TABLE public.dealers OWNER TO postgres;
-- ddl-end --

-- object: public.users_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.users_id_seq CASCADE;
CREATE SEQUENCE public.users_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.users_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.link_database_users | type: TABLE --
-- DROP TABLE IF EXISTS public.link_database_users CASCADE;
CREATE TABLE public.link_database_users (
	id serial NOT NULL,
	uuid uuid NOT NULL,
	CONSTRAINT no_double_uuid_link_database_users UNIQUE (uuid),
	CONSTRAINT link_database_users_pk PRIMARY KEY (id)

);
-- ddl-end --

-- object: time_last_update_brand_trigger | type: TRIGGER --
-- DROP TRIGGER IF EXISTS time_last_update_brand_trigger ON public.brands CASCADE;
CREATE TRIGGER time_last_update_brand_trigger
	BEFORE UPDATE
	ON public.brands
	FOR EACH ROW
	EXECUTE PROCEDURE public.update_modified_column();
-- ddl-end --

-- object: time_last_update_deal_trigger | type: TRIGGER --
-- DROP TRIGGER IF EXISTS time_last_update_deal_trigger ON public.deals CASCADE;
CREATE TRIGGER time_last_update_deal_trigger
	BEFORE UPDATE
	ON public.deals
	FOR EACH ROW
	EXECUTE PROCEDURE public.update_modified_column();
-- ddl-end --

-- object: time_last_update_dealer_trigger | type: TRIGGER --
-- DROP TRIGGER IF EXISTS time_last_update_dealer_trigger ON public.dealers CASCADE;
CREATE TRIGGER time_last_update_dealer_trigger
	BEFORE UPDATE
	ON public.dealers
	FOR EACH ROW
	EXECUTE PROCEDURE public.update_modified_column();
-- ddl-end --

-- object: public.products | type: TABLE --
-- DROP TABLE IF EXISTS public.products CASCADE;
CREATE TABLE public.products (
	id bigserial NOT NULL,
	isin_code text,
	product_rating smallint,
	official_product_link text,
	brand_id integer NOT NULL,
	dealer_id integer,
	CONSTRAINT products_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.products OWNER TO postgres;
-- ddl-end --

-- object: public.is_depreciated | type: TABLE --
-- DROP TABLE IF EXISTS public.is_depreciated CASCADE;
CREATE TABLE public.is_depreciated (
	id bigserial NOT NULL,
	date_row_created timestamp with time zone,
	date_row_modified timestamp with time zone,
	link_database_user_id integer,
	CONSTRAINT is_depreciated_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.is_depreciated OWNER TO postgres;
-- ddl-end --

-- object: public."OLD_geographic_department" | type: TABLE --
-- DROP TABLE IF EXISTS public."OLD_geographic_department" CASCADE;
CREATE TABLE public."OLD_geographic_department" (
	id smallserial NOT NULL,
	name text,
	departement_code smallint,
	deal_geographic_reference_id bigint,
	deal_id bigint,
	CONSTRAINT geographic_department_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public."OLD_geographic_department" OWNER TO postgres;
-- ddl-end --

-- object: public.countries | type: TABLE --
-- DROP TABLE IF EXISTS public.countries CASCADE;
CREATE TABLE public.countries (
	id smallserial NOT NULL,
	name text,
	CONSTRAINT countries_pk PRIMARY KEY (id),
	CONSTRAINT unique_country UNIQUE (name)

);
-- ddl-end --
ALTER TABLE public.countries OWNER TO postgres;
-- ddl-end --

-- object: public."OLD_city" | type: TABLE --
-- DROP TABLE IF EXISTS public."OLD_city" CASCADE;
CREATE TABLE public."OLD_city" (
	id serial NOT NULL,
	geographique_departement_id smallint,
	deal_id bigint,
	CONSTRAINT city_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public."OLD_city" OWNER TO postgres;
-- ddl-end --

-- object: public.border_countries | type: TABLE --
-- DROP TABLE IF EXISTS public.border_countries CASCADE;
CREATE TABLE public.border_countries (
	id smallserial NOT NULL,
	origin_country smallint,
	border_country smallint,
	CONSTRAINT not_be_your_own_neighbour CHECK ((origin_country <> border_country)),
	CONSTRAINT border_countries_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.border_countries OWNER TO postgres;
-- ddl-end --

-- object: public.categories_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.categories_id_seq CASCADE;
CREATE SEQUENCE public.categories_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.deal_categories | type: TABLE --
-- DROP TABLE IF EXISTS public.deal_categories CASCADE;
CREATE TABLE public.deal_categories (
	id smallserial NOT NULL,
	title text NOT NULL,
	parent_id smallint,
	reference_order smallint,
	CONSTRAINT categories_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.deal_categories IS 'https://sqlpro.developpez.com/cours/arborescence/
https://stackoverflow.com/questions/2175882/how-to-represent-a-data-tree-in-sql';
-- ddl-end --
ALTER TABLE public.deal_categories OWNER TO postgres;
-- ddl-end --

-- object: public.geographic_positions | type: TABLE --
-- DROP TABLE IF EXISTS public.geographic_positions CASCADE;
CREATE TABLE public.geographic_positions (
	id serial NOT NULL,
	geographic_name text NOT NULL,
	code_reference smallint,
	country_id smallint NOT NULL,
	geographic_data_type_id smallint NOT NULL,
	CONSTRAINT deal_geographic_positions_pk PRIMARY KEY (id),
	CONSTRAINT geographic_positions_name_unique UNIQUE (geographic_name)

);
-- ddl-end --
COMMENT ON COLUMN public.geographic_positions.code_reference IS 'code postal ou code département';
-- ddl-end --
ALTER TABLE public.geographic_positions OWNER TO postgres;
-- ddl-end --

-- object: public.geographic_data_types | type: TABLE --
-- DROP TABLE IF EXISTS public.geographic_data_types CASCADE;
CREATE TABLE public.geographic_data_types (
	id smallserial NOT NULL,
	geographic_type text,
	CONSTRAINT geographic_data_types_pk PRIMARY KEY (id),
	CONSTRAINT geographic_data_types_unique_name UNIQUE (geographic_type)

);
-- ddl-end --
ALTER TABLE public.geographic_data_types OWNER TO postgres;
-- ddl-end --

-- object: public.dealer_partnership_types | type: TABLE --
-- DROP TABLE IF EXISTS public.dealer_partnership_types CASCADE;
CREATE TABLE public.dealer_partnership_types (
	id smallint NOT NULL,
	parthnership_type text,
	CONSTRAINT dealer_partnership_type_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.dealer_partnership_types OWNER TO postgres;
-- ddl-end --

-- object: public.deal_geographic_positions | type: TABLE --
-- DROP TABLE IF EXISTS public.deal_geographic_positions CASCADE;
CREATE TABLE public.deal_geographic_positions (
	deal_id bigint,
	geographic_position_id integer
);
-- ddl-end --
ALTER TABLE public.deal_geographic_positions OWNER TO postgres;
-- ddl-end --

-- object: public.view_geographic_position_with_types | type: VIEW --
-- DROP VIEW IF EXISTS public.view_geographic_position_with_types CASCADE;
CREATE VIEW public.view_geographic_position_with_types
AS 

SELECT geographic_positions.id,
    geographic_positions.geographic_name,
    geographic_data_types.geographic_type
   FROM (geographic_positions
     JOIN geographic_data_types ON ((geographic_data_types.id = geographic_positions.id)));
-- ddl-end --
ALTER VIEW public.view_geographic_position_with_types OWNER TO postgres;
-- ddl-end --

-- object: fk_brand_deal | type: CONSTRAINT --
-- ALTER TABLE public.deals DROP CONSTRAINT IF EXISTS fk_brand_deal CASCADE;
ALTER TABLE public.deals ADD CONSTRAINT fk_brand_deal FOREIGN KEY (brand_id)
REFERENCES public.brands (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_dealer_deal | type: CONSTRAINT --
-- ALTER TABLE public.deals DROP CONSTRAINT IF EXISTS fk_dealer_deal CASCADE;
ALTER TABLE public.deals ADD CONSTRAINT fk_dealer_deal FOREIGN KEY (dealer_id)
REFERENCES public.dealers (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_link_database_user_deal | type: CONSTRAINT --
-- ALTER TABLE public.deals DROP CONSTRAINT IF EXISTS fk_link_database_user_deal CASCADE;
ALTER TABLE public.deals ADD CONSTRAINT fk_link_database_user_deal FOREIGN KEY (link_database_user_id)
REFERENCES public.link_database_users (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_targetdealconsumercountry_countries | type: CONSTRAINT --
-- ALTER TABLE public.deals DROP CONSTRAINT IF EXISTS fk_targetdealconsumercountry_countries CASCADE;
ALTER TABLE public.deals ADD CONSTRAINT fk_targetdealconsumercountry_countries FOREIGN KEY (deal_target_counsumer_country)
REFERENCES public.countries (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_category | type: CONSTRAINT --
-- ALTER TABLE public.deals DROP CONSTRAINT IF EXISTS fk_category CASCADE;
ALTER TABLE public.deals ADD CONSTRAINT fk_category FOREIGN KEY (category_id)
REFERENCES public.deal_categories (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_deal_product | type: CONSTRAINT --
-- ALTER TABLE public.deals DROP CONSTRAINT IF EXISTS fk_deal_product CASCADE;
ALTER TABLE public.deals ADD CONSTRAINT fk_deal_product FOREIGN KEY (product_id)
REFERENCES public.products (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_dealer_partnership_type_dealer | type: CONSTRAINT --
-- ALTER TABLE public.dealers DROP CONSTRAINT IF EXISTS fk_dealer_partnership_type_dealer CASCADE;
ALTER TABLE public.dealers ADD CONSTRAINT fk_dealer_partnership_type_dealer FOREIGN KEY (dealer_partership_type_id)
REFERENCES public.dealer_partnership_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_brand_product | type: CONSTRAINT --
-- ALTER TABLE public.products DROP CONSTRAINT IF EXISTS fk_brand_product CASCADE;
ALTER TABLE public.products ADD CONSTRAINT fk_brand_product FOREIGN KEY (brand_id)
REFERENCES public.brands (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_dealer_product | type: CONSTRAINT --
-- ALTER TABLE public.products DROP CONSTRAINT IF EXISTS fk_dealer_product CASCADE;
ALTER TABLE public.products ADD CONSTRAINT fk_dealer_product FOREIGN KEY (dealer_id)
REFERENCES public.dealers (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_link_database_user_id_is_depreciated | type: CONSTRAINT --
-- ALTER TABLE public.is_depreciated DROP CONSTRAINT IF EXISTS fk_link_database_user_id_is_depreciated CASCADE;
ALTER TABLE public.is_depreciated ADD CONSTRAINT fk_link_database_user_id_is_depreciated FOREIGN KEY (link_database_user_id)
REFERENCES public.link_database_users (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fy_city_geographicdepartement | type: CONSTRAINT --
-- ALTER TABLE public."OLD_city" DROP CONSTRAINT IF EXISTS fy_city_geographicdepartement CASCADE;
ALTER TABLE public."OLD_city" ADD CONSTRAINT fy_city_geographicdepartement FOREIGN KEY (id)
REFERENCES public."OLD_geographic_department" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_orignecountry | type: CONSTRAINT --
-- ALTER TABLE public.border_countries DROP CONSTRAINT IF EXISTS fk_orignecountry CASCADE;
ALTER TABLE public.border_countries ADD CONSTRAINT fk_orignecountry FOREIGN KEY (origin_country)
REFERENCES public.countries (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_border_country | type: CONSTRAINT --
-- ALTER TABLE public.border_countries DROP CONSTRAINT IF EXISTS fk_border_country CASCADE;
ALTER TABLE public.border_countries ADD CONSTRAINT fk_border_country FOREIGN KEY (border_country)
REFERENCES public.countries (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_deal_categories_deal_categories | type: CONSTRAINT --
-- ALTER TABLE public.deal_categories DROP CONSTRAINT IF EXISTS fk_deal_categories_deal_categories CASCADE;
ALTER TABLE public.deal_categories ADD CONSTRAINT fk_deal_categories_deal_categories FOREIGN KEY (parent_id)
REFERENCES public.deal_categories (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_geographic_data_types_deal_geographic_positions | type: CONSTRAINT --
-- ALTER TABLE public.geographic_positions DROP CONSTRAINT IF EXISTS fk_geographic_data_types_deal_geographic_positions CASCADE;
ALTER TABLE public.geographic_positions ADD CONSTRAINT fk_geographic_data_types_deal_geographic_positions FOREIGN KEY (geographic_data_type_id)
REFERENCES public.geographic_data_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_contries_deal_geographic_positions | type: CONSTRAINT --
-- ALTER TABLE public.geographic_positions DROP CONSTRAINT IF EXISTS fk_contries_deal_geographic_positions CASCADE;
ALTER TABLE public.geographic_positions ADD CONSTRAINT fk_contries_deal_geographic_positions FOREIGN KEY (country_id)
REFERENCES public.countries (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_geographic_positions_deal_geographic_positions | type: CONSTRAINT --
-- ALTER TABLE public.deal_geographic_positions DROP CONSTRAINT IF EXISTS fk_geographic_positions_deal_geographic_positions CASCADE;
ALTER TABLE public.deal_geographic_positions ADD CONSTRAINT fk_geographic_positions_deal_geographic_positions FOREIGN KEY (geographic_position_id)
REFERENCES public.geographic_positions (id) MATCH FULL
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_deals_deal_geographic_positions | type: CONSTRAINT --
-- ALTER TABLE public.deal_geographic_positions DROP CONSTRAINT IF EXISTS fk_deals_deal_geographic_positions CASCADE;
ALTER TABLE public.deal_geographic_positions ADD CONSTRAINT fk_deals_deal_geographic_positions FOREIGN KEY (deal_id)
REFERENCES public.deals (id) MATCH FULL
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --



