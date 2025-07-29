--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: product; Type: TABLE; Schema: public; Owner: newadmin
--

CREATE TABLE public.product (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    name character varying(70) NOT NULL,
    type character varying(70),
    brand character varying(70),
    unit character varying(50),
    sku character varying(50),
    create_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    delete_at timestamp without time zone
);


ALTER TABLE public.product OWNER TO newadmin;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: newadmin
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_id_seq OWNER TO newadmin;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: newadmin
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: purchase; Type: TABLE; Schema: public; Owner: newadmin
--

CREATE TABLE public.purchase (
    id integer NOT NULL,
    code_transaction character varying(50) NOT NULL,
    create_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    delete_at timestamp without time zone,
    quantity numeric(15,2)
);


ALTER TABLE public.purchase OWNER TO newadmin;

--
-- Name: purchase_id_seq; Type: SEQUENCE; Schema: public; Owner: newadmin
--

CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_id_seq OWNER TO newadmin;

--
-- Name: purchase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: newadmin
--

ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;


--
-- Name: stock; Type: TABLE; Schema: public; Owner: newadmin
--

CREATE TABLE public.stock (
    id integer NOT NULL,
    code_product character varying(30) NOT NULL,
    quantity numeric(15,2) DEFAULT 0,
    create_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    delete_at timestamp without time zone
);


ALTER TABLE public.stock OWNER TO newadmin;

--
-- Name: stock_id_seq; Type: SEQUENCE; Schema: public; Owner: newadmin
--

CREATE SEQUENCE public.stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_id_seq OWNER TO newadmin;

--
-- Name: stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: newadmin
--

ALTER SEQUENCE public.stock_id_seq OWNED BY public.stock.id;


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: newadmin
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: purchase id; Type: DEFAULT; Schema: public; Owner: newadmin
--

ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);


--
-- Name: stock id; Type: DEFAULT; Schema: public; Owner: newadmin
--

ALTER TABLE ONLY public.stock ALTER COLUMN id SET DEFAULT nextval('public.stock_id_seq'::regclass);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: newadmin
--

COPY public.product (id, code, name, type, brand, unit, sku, create_at, delete_at) FROM stdin;
4	0001	Kopi kapal api	Minuman	Kapal Api	Bungkus	Kpi-0001-bks	2025-07-29 22:43:43.334697	\N
5	0002	Teh Sariwangi	Minuman	Sariwangi	Pak	Swi-0002-pak	2025-07-29 22:44:35.437146	\N
6	0003	Mie Sedap 	Makanan	Sedap	Bungkus	Msd-0003-bks	2025-07-29 22:45:21.491594	\N
7	0004	Kopi Torabika	Minuman	Torabika	Pak	Tbk-0004-pak	2025-07-29 22:46:36.105986	\N
8	0005	Indomie	Makanan	Indomie	Bungkus	Idm-0005-bks	2025-07-29 22:47:30.985085	\N
9	0006	Indomilk	Minuman	Indomilk	Kotak	Inm-0006-ktk	2025-07-29 22:49:06.677969	\N
10	0007	Permen Mentos	Lainnya	Mentos	Biji	Mts-0007-bij	2025-07-29 22:51:27.128016	\N
12	0009	Batre Abc	Elektronik	Abc	Biji	Abc-0009-bij	2025-07-29 22:53:35.042641	\N
11	0008	Aqua galon	Minuman	Aqua	Galon	Agn-0008-gal	2025-07-29 22:52:23.601937	\N
13	0010	Lampu Osram	Elektronik	Osram	Buah	Osr-0010-bah	2025-07-29 22:55:48.613583	\N
\.


--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: newadmin
--

COPY public.purchase (id, code_transaction, create_at, delete_at, quantity) FROM stdin;
4	0002	2025-07-29 22:21:17.682824	\N	100.00
5	0005	2025-07-29 22:57:13.726547	\N	1000.00
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: newadmin
--

COPY public.stock (id, code_product, quantity, create_at, delete_at) FROM stdin;
5	0002	9900.00	2025-07-29 22:16:38.263107	\N
6	0008	100000.00	2025-07-29 22:56:01.224211	\N
7	0010	9000.00	2025-07-29 22:56:09.777436	\N
8	0001	1000.00	2025-07-29 22:56:17.057434	\N
9	0007	10000.00	2025-07-29 22:56:29.495432	\N
10	0005	99000.00	2025-07-29 22:56:45.673351	\N
\.


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: newadmin
--

SELECT pg_catalog.setval('public.product_id_seq', 13, true);


--
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: newadmin
--

SELECT pg_catalog.setval('public.purchase_id_seq', 5, true);


--
-- Name: stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: newadmin
--

SELECT pg_catalog.setval('public.stock_id_seq', 10, true);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: newadmin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: newadmin
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);


--
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: newadmin
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

