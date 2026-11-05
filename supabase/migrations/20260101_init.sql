-- ==============================================================================
-- Schema do Banco de Dados PostgreSQL - Supabase
-- Sistema: Inova — CRM Odontológico
-- Gerado por afCode Platform (Clone Fiel & Código-Fonte Liberado)
-- ==============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela Principal de Entidades
CREATE TABLE IF NOT EXISTS public.inova_crm_odontol_gico_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) DEFAULT 'saas',
    status VARCHAR(50) DEFAULT 'active',
    data JSONB DEFAULT '{}'::jsonb,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Tabela de Pedidos / Transações Comerciais
CREATE TABLE IF NOT EXISTS public.inova_crm_odontol_gico_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    amount NUMERIC(10, 2) NOT NULL DEFAULT 177.9,
    payment_method VARCHAR(50) DEFAULT 'pix',
    payment_status VARCHAR(50) DEFAULT 'approved',
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Índices de Alta Performance
CREATE INDEX IF NOT EXISTS idx_inova_crm_odontol_gico_user_id ON public.inova_crm_odontol_gico_records(user_id);
CREATE INDEX IF NOT EXISTS idx_inova_crm_odontol_gico_status ON public.inova_crm_odontol_gico_records(status);

-- Ativação de Row Level Security (RLS)
ALTER TABLE public.inova_crm_odontol_gico_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inova_crm_odontol_gico_transactions ENABLE ROW LEVEL SECURITY;

-- Políticas de Isolamento por Usuário (Multi-Tenant Seguro)
CREATE POLICY "Leitura e escrita de dados próprios" ON public.inova_crm_odontol_gico_records
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Transações acessadas apenas pelo dono" ON public.inova_crm_odontol_gico_transactions
    FOR ALL USING (auth.uid() = user_id);
