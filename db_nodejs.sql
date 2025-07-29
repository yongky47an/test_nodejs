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
2	0002	Teh Sariwangiii	\N	\N	\N	\N	2025-07-29 16:48:22.742264	\N
\.


--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: newadmin
--

COPY public.purchase (id, code_transaction, create_at, delete_at, quantity) FROM stdin;
1	12345	2025-07-29 17:20:14.640125	\N	99999.00
2	111213131	2025-07-29 18:56:05.973892	\N	234323.00
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: newadmin
--

COPY public.stock (id, code_product, quantity, create_at, delete_at) FROM stdin;
1	00032	399.00	2025-07-29 17:04:26.500817	\N
2	1000	100000.00	2025-07-29 17:12:34.062211	\N
3	39432492	42343242.00	2025-07-29 18:47:21.187648	\N
\.


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: newadmin
--

SELECT pg_catalog.setval('public.product_id_seq', 2, true);


--
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: newadmin
--

SELECT pg_catalog.setval('public.purchase_id_seq', 2, true);


--
-- Name: stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: newadmin
--

SELECT pg_catalog.setval('public.stock_id_seq', 3, true);


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

