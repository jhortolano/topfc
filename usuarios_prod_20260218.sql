--
-- PostgreSQL database dump
--

\restrict FfhQKlxSnOjgucCrmEMZdKWcVfBWBk1z45b1MSb8avLTx3peYDaq0Rf6MPFUXIo

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', 'ff1dccb8-00bc-4042-a869-3a55773f3701', 'authenticated', 'authenticated', 'rjgcolino@gmail.com', '$2a$10$fLSDv7bFPSF2N3kk259OoeV7So8SB6RwbF58l4omEsH2B1nnmJj5a', '2026-02-16 15:24:29.591924+00', NULL, '', '2026-02-16 15:24:06.248757+00', '', NULL, '', '', NULL, '2026-02-16 15:24:29.599753+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "ff1dccb8-00bc-4042-a869-3a55773f3701", "nick": "errejota", "email": "rjgcolino@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-02-16 15:24:06.156321+00', '2026-02-16 15:24:29.647+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', 'e2c0c4df-3aba-4f3e-9511-49df6b02b87b', 'authenticated', 'authenticated', 'javigr77@gmail.com', '$2a$10$XTHd4KWbbq7g.vkYEb28iuxgQ4wwKlosLkyat.ZLc1FN4GqNh2cfa', '2026-02-17 15:36:36.276768+00', NULL, '', '2026-02-17 15:36:20.341497+00', '', NULL, '', '', NULL, '2026-02-17 15:36:36.287763+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "e2c0c4df-3aba-4f3e-9511-49df6b02b87b", "nick": "Javi GT", "email": "javigr77@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-02-17 15:36:20.289572+00', '2026-02-17 15:36:36.307396+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', 'c06aa55d-9cd6-4f14-8d85-6c5739913994', 'authenticated', 'authenticated', 'jhortolano@gmail.com', '$2a$10$7KQk0zHxgDttQg3KPdPQa.TANNA57vOqkIoeONVSjnImsNJ6CDH4C', '2026-02-16 14:42:03.862989+00', NULL, '', '2026-02-16 14:41:52.452973+00', '', NULL, '', '', NULL, '2026-02-17 17:06:45.652754+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "c06aa55d-9cd6-4f14-8d85-6c5739913994", "nick": "Mr.Macson", "email": "jhortolano@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-02-16 14:41:52.428558+00', '2026-02-18 10:31:43.494117+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- PostgreSQL database dump complete
--

\unrestrict FfhQKlxSnOjgucCrmEMZdKWcVfBWBk1z45b1MSb8avLTx3peYDaq0Rf6MPFUXIo

