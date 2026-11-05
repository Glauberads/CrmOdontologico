-- ==============================================================================
-- Schema do Banco de Dados PostgreSQL - Supabase
-- Sistema: CRM Odonto
-- ==============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela Principal de Registros / Pacientes / Prontuarios
CREATE TABLE IF NOT EXISTS public.crm_odonto_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) DEFAULT 'odonto',
    status VARCHAR(50) DEFAULT 'active',
    data JSONB DEFAULT '{}'::jsonb,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Tabela de Pagamentos e Transações Financeiras
CREATE TABLE IF NOT EXISTS public.crm_odonto_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    payment_method VARCHAR(50) DEFAULT 'pix',
    payment_status VARCHAR(50) DEFAULT 'approved',
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Índices de Alta Performance
CREATE INDEX IF NOT EXISTS idx_crm_odonto_user_id ON public.crm_odonto_records(user_id);
CREATE INDEX IF NOT EXISTS idx_crm_odonto_status ON public.crm_odonto_records(status);

-- Ativação de Row Level Security (RLS)
ALTER TABLE public.crm_odonto_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crm_odonto_transactions ENABLE ROW LEVEL SECURITY;

-- Políticas de Isolamento por Usuário (Multi-Tenant Seguro)
CREATE POLICY "Leitura e escrita de dados proprios" ON public.crm_odonto_records
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Transacoes acessadas apenas pelo dono" ON public.crm_odonto_transactions
    FOR ALL USING (auth.uid() = user_id);
