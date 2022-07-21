--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

-- Started on 2022-07-18 23:08:36

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

--
-- TOC entry 3012 (class 1262 OID 16505)
-- Name: reclamacoes; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE reclamacoes WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';


ALTER DATABASE reclamacoes OWNER TO postgres;

\connect reclamacoes

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
-- TOC entry 202 (class 1259 OID 16517)
-- Name: tbl_dim_calendario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_dim_calendario (
    pk_calendario integer NOT NULL,
    ano integer,
    trimestre integer,
    "trimestre descr curta" text,
    "trimestre descr longa" text
);


ALTER TABLE public.tbl_dim_calendario OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16525)
-- Name: tbl_dim_instituicoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_dim_instituicoes (
    cnpj integer NOT NULL,
    nome_instituicao text NOT NULL
);


ALTER TABLE public.tbl_dim_instituicoes OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16514)
-- Name: tbl_fato_reclamacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_fato_reclamacoes (
    fk_calendario integer NOT NULL,
    fk_cnpj integer NOT NULL,
    quantidade_reclamacoes_reguladas_procedentes integer,
    quantidade_reclamacoes_reguladas_outras integer,
    quantidade_reclamacoes_nao_reguladas integer,
    quantidade_total_reclamacoes integer,
    quantidade_total_clientes_ccs_e_scr integer,
    quantidade_clientes_ccs integer,
    quantidade_clientes_scr integer
);


ALTER TABLE public.tbl_fato_reclamacoes OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16506)
-- Name: tbl_fato_tarifas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_fato_tarifas (
    data_vigencia date,
    descr_tarifa text,
    fk_calendario integer,
    fk_cnpj integer NOT NULL,
    pk_tarifa integer NOT NULL,
    tipo_tarifa text,
    tipo_valor text,
    valor_maximo numeric(10,2),
    periodicidade text
);


ALTER TABLE public.tbl_fato_tarifas OWNER TO postgres;

--
-- TOC entry 3005 (class 0 OID 16517)
-- Dependencies: 202
-- Data for Name: tbl_dim_calendario; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3006 (class 0 OID 16525)
-- Dependencies: 203
-- Data for Name: tbl_dim_instituicoes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3004 (class 0 OID 16514)
-- Dependencies: 201
-- Data for Name: tbl_fato_reclamacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3003 (class 0 OID 16506)
-- Dependencies: 200
-- Data for Name: tbl_fato_tarifas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2866 (class 2606 OID 16524)
-- Name: tbl_dim_calendario tbl_dim_calendario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_dim_calendario
    ADD CONSTRAINT tbl_dim_calendario_pkey PRIMARY KEY (pk_calendario);


--
-- TOC entry 2868 (class 2606 OID 16537)
-- Name: tbl_dim_instituicoes tbl_dim_instituicoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_dim_instituicoes
    ADD CONSTRAINT tbl_dim_instituicoes_pkey PRIMARY KEY (cnpj);


--
-- TOC entry 2864 (class 2606 OID 16513)
-- Name: tbl_fato_tarifas tbl_fato_reclamacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_fato_tarifas
    ADD CONSTRAINT tbl_fato_reclamacoes_pkey PRIMARY KEY (pk_tarifa);


--
-- TOC entry 2871 (class 2606 OID 16531)
-- Name: tbl_fato_reclamacoes tbl_fato_reclamacoes_fKey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_fato_reclamacoes
    ADD CONSTRAINT "tbl_fato_reclamacoes_fKey" FOREIGN KEY (fk_calendario) REFERENCES public.tbl_dim_calendario(pk_calendario) NOT VALID;


--
-- TOC entry 2872 (class 2606 OID 16538)
-- Name: tbl_fato_reclamacoes tbl_fato_reclamacoes_fKey_cnpj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_fato_reclamacoes
    ADD CONSTRAINT "tbl_fato_reclamacoes_fKey_cnpj" FOREIGN KEY (fk_cnpj) REFERENCES public.tbl_dim_instituicoes(cnpj) NOT VALID;


--
-- TOC entry 2870 (class 2606 OID 16548)
-- Name: tbl_fato_tarifas tbl_fato_reclamacoes_fkey_calendario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_fato_tarifas
    ADD CONSTRAINT tbl_fato_reclamacoes_fkey_calendario FOREIGN KEY (fk_calendario) REFERENCES public.tbl_dim_calendario(pk_calendario) NOT VALID;


--
-- TOC entry 2869 (class 2606 OID 16543)
-- Name: tbl_fato_tarifas tbl_fato_reclamacoes_fkey_cnpj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_fato_tarifas
    ADD CONSTRAINT tbl_fato_reclamacoes_fkey_cnpj FOREIGN KEY (fk_cnpj) REFERENCES public.tbl_dim_instituicoes(cnpj) NOT VALID;


--
-- TOC entry 3013 (class 0 OID 0)
-- Dependencies: 3012
-- Name: DATABASE reclamacoes; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON DATABASE reclamacoes FROM postgres;
GRANT ALL ON DATABASE reclamacoes TO postgres WITH GRANT OPTION;


-- Completed on 2022-07-18 23:08:37

--
-- PostgreSQL database dump complete
--

