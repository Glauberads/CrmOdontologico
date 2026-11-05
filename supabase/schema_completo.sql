
-- ==================== MIGRATION 1 ====================
-- Create dentistas table (VERSÃO CORRIGIDA)
CREATE TABLE public.dentistas (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  cro TEXT NOT NULL UNIQUE,
  especialidade TEXT NOT NULL,
  telefone TEXT NOT NULL,
  email TEXT NOT NULL,
  cpf TEXT NOT NULL UNIQUE,
  endereco TEXT,
  data_nascimento DATE,
  status TEXT NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo')),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.dentistas ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (CORRIGIDAS - sem lógica circular)
CREATE POLICY "Users can view their own dentistas" 
ON public.dentistas 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own dentistas" 
ON public.dentistas 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own dentistas" 
ON public.dentistas 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own dentistas" 
ON public.dentistas 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create function to update timestamps (ADICIONADA)
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Create trigger for automatic timestamp updates (AGORA FUNCIONA)
CREATE TRIGGER update_dentistas_updated_at
BEFORE UPDATE ON public.dentistas
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create index for better performance
CREATE INDEX idx_dentistas_user_id ON public.dentistas(user_id);
CREATE INDEX idx_dentistas_cro ON public.dentistas(cro);
CREATE INDEX idx_dentistas_status ON public.dentistas(status);

-- Índices adicionais recomendados
CREATE INDEX idx_dentistas_email ON public.dentistas(email);
CREATE INDEX idx_dentistas_cpf ON public.dentistas(cpf);
CREATE INDEX idx_dentistas_nome ON public.dentistas USING gin(to_tsvector('portuguese', nome));

-- Validações adicionais
ALTER TABLE public.dentistas ADD CONSTRAINT check_cro_format 
CHECK (cro ~ '^[0-9]{4,6}$');

ALTER TABLE public.dentistas ADD CONSTRAINT check_cpf_format 
CHECK (cpf ~ '^[0-9]{11}$');

-- ==================== MIGRATION 2 ====================
-- Fix RLS: remove recursive policies and enforce per-user ownership
DROP POLICY IF EXISTS "Users can view dentistas from their organization" ON public.dentistas;
DROP POLICY IF EXISTS "Users can create dentistas" ON public.dentistas;
DROP POLICY IF EXISTS "Users can update dentistas from their organization" ON public.dentistas;
DROP POLICY IF EXISTS "Users can delete dentistas from their organization" ON public.dentistas;

-- Minimal, secure RLS: each user can only access their own rows
CREATE POLICY "Dentistas are viewable by owner"
ON public.dentistas
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Dentistas insert by owner"
ON public.dentistas
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Dentistas update by owner"
ON public.dentistas
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Dentistas delete by owner"
ON public.dentistas
FOR DELETE
USING (auth.uid() = user_id);

-- ==================== MIGRATION 3 ====================
-- Create pacientes table
CREATE TABLE public.pacientes (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    nome TEXT NOT NULL,
    email TEXT NOT NULL,
    telefone TEXT NOT NULL,
    data_nascimento DATE,
    ultima_consulta DATE,
    status TEXT NOT NULL DEFAULT 'Ativo',
    endereco TEXT,
    cpf TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.pacientes ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Pacientes are viewable by owner" 
ON public.pacientes 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Pacientes insert by owner" 
ON public.pacientes 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Pacientes update by owner" 
ON public.pacientes 
FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Pacientes delete by owner" 
ON public.pacientes 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_pacientes_updated_at
BEFORE UPDATE ON public.pacientes
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 4 ====================
-- Create funcionarios table
CREATE TABLE public.funcionarios (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  nome TEXT NOT NULL,
  cargo TEXT NOT NULL,
  telefone TEXT NOT NULL,
  email TEXT NOT NULL,
  data_admissao DATE,
  status TEXT NOT NULL DEFAULT 'Ativo',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.funcionarios ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for funcionarios
CREATE POLICY "Funcionarios are viewable by owner" 
ON public.funcionarios 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Funcionarios insert by owner" 
ON public.funcionarios 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Funcionarios update by owner" 
ON public.funcionarios 
FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Funcionarios delete by owner" 
ON public.funcionarios 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_funcionarios_updated_at
BEFORE UPDATE ON public.funcionarios
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 5 ====================
-- Create fornecedores table
CREATE TABLE public.fornecedores (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  nome TEXT NOT NULL,
  cnpj TEXT,
  contato TEXT NOT NULL,
  telefone TEXT NOT NULL,
  email TEXT NOT NULL,
  endereco TEXT,
  categoria TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Ativo',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.fornecedores ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for fornecedores
CREATE POLICY "Fornecedores are viewable by owner" 
ON public.fornecedores 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Fornecedores insert by owner" 
ON public.fornecedores 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Fornecedores update by owner" 
ON public.fornecedores 
FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Fornecedores delete by owner" 
ON public.fornecedores 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_fornecedores_updated_at
BEFORE UPDATE ON public.fornecedores
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 6 ====================
-- Create convenios table
CREATE TABLE public.convenios (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  nome TEXT NOT NULL,
  codigo TEXT,
  tipo TEXT NOT NULL,
  percentual_cobertura NUMERIC(5,2),
  valor_consulta NUMERIC(10,2),
  carencia_dias INTEGER DEFAULT 0,
  observacoes TEXT,
  status TEXT NOT NULL DEFAULT 'Ativo',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.convenios ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for convenios
CREATE POLICY "Convenios are viewable by owner" 
ON public.convenios 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Convenios insert by owner" 
ON public.convenios 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Convenios update by owner" 
ON public.convenios 
FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Convenios delete by owner" 
ON public.convenios 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_convenios_updated_at
BEFORE UPDATE ON public.convenios
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 7 ====================
-- Create patrimonio table
CREATE TABLE public.patrimonio (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  item TEXT NOT NULL,
  codigo TEXT NOT NULL,
  categoria TEXT NOT NULL,
  valor NUMERIC NOT NULL,
  data_aquisicao DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'Ativo',
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.patrimonio ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own patrimonio" 
ON public.patrimonio 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own patrimonio" 
ON public.patrimonio 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own patrimonio" 
ON public.patrimonio 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own patrimonio" 
ON public.patrimonio 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_patrimonio_updated_at
BEFORE UPDATE ON public.patrimonio
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 8 ====================
-- Create laboratorio table
CREATE TABLE public.laboratorio (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente TEXT NOT NULL,
  procedimento TEXT NOT NULL,
  laboratorio TEXT NOT NULL,
  data_envio DATE NOT NULL,
  data_retorno DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'Enviado',
  valor NUMERIC NOT NULL,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.laboratorio ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own laboratorio" 
ON public.laboratorio 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own laboratorio" 
ON public.laboratorio 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own laboratorio" 
ON public.laboratorio 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own laboratorio" 
ON public.laboratorio 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_laboratorio_updated_at
BEFORE UPDATE ON public.laboratorio
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 9 ====================
-- Create estoque table
CREATE TABLE public.estoque (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  item TEXT NOT NULL,
  codigo TEXT NOT NULL,
  categoria TEXT NOT NULL,
  estoque INTEGER NOT NULL DEFAULT 0,
  minimo INTEGER NOT NULL DEFAULT 0,
  maximo INTEGER NOT NULL DEFAULT 0,
  valor_unitario NUMERIC NOT NULL DEFAULT 0,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.estoque ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own estoque" 
ON public.estoque 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own estoque" 
ON public.estoque 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own estoque" 
ON public.estoque 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own estoque" 
ON public.estoque 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_estoque_updated_at
BEFORE UPDATE ON public.estoque
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 10 ====================
-- Create ficha_clinica table
CREATE TABLE public.ficha_clinica (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  
  -- Contato de Emergência
  contato_emergencia_nome TEXT,
  contato_emergencia_telefone TEXT,
  contato_emergencia_parentesco TEXT,
  
  -- Anamnese
  queixa_principal TEXT,
  historico_medico TEXT,
  alergias TEXT,
  
  -- Exame Clínico
  pressao_arterial TEXT,
  temperatura TEXT,
  peso TEXT,
  exame_extraoral TEXT,
  exame_intraoral TEXT,
  
  -- Diagnóstico e Tratamento
  diagnostico TEXT,
  plano_tratamento TEXT,
  observacoes TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  
  -- Um paciente tem apenas uma ficha clínica
  UNIQUE(paciente_id)
);

-- Enable Row Level Security
ALTER TABLE public.ficha_clinica ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own ficha_clinica" 
ON public.ficha_clinica 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own ficha_clinica" 
ON public.ficha_clinica 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ficha_clinica" 
ON public.ficha_clinica 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ficha_clinica" 
ON public.ficha_clinica 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_ficha_clinica_updated_at
BEFORE UPDATE ON public.ficha_clinica
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 11 ====================
-- Create odontograma table
CREATE TABLE public.odontograma (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  dados_dentes JSONB DEFAULT '{}'::jsonb,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(paciente_id)
);

-- Enable Row Level Security
ALTER TABLE public.odontograma ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own odontograma"
ON public.odontograma
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own odontograma"
ON public.odontograma
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own odontograma"
ON public.odontograma
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own odontograma"
ON public.odontograma
FOR DELETE
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_odontograma_updated_at
BEFORE UPDATE ON public.odontograma
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 12 ====================
-- Create ortodontia table
CREATE TABLE public.ortodontia (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  data_inicio DATE,
  previsao_termino DATE,
  tipo_aparelho TEXT,
  diagnostico TEXT,
  plano_tratamento TEXT,
  progresso TEXT,
  proxima_consulta DATE,
  observacoes TEXT,
  status TEXT DEFAULT 'Em Andamento',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(paciente_id)
);

-- Enable Row Level Security
ALTER TABLE public.ortodontia ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own ortodontia"
ON public.ortodontia
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own ortodontia"
ON public.ortodontia
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ortodontia"
ON public.ortodontia
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ortodontia"
ON public.ortodontia
FOR DELETE
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_ortodontia_updated_at
BEFORE UPDATE ON public.ortodontia
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 13 ====================
-- Create fotos table
CREATE TABLE public.fotos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  titulo TEXT NOT NULL,
  imagem_base64 TEXT NOT NULL,
  tipo TEXT,
  data_foto DATE,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.fotos ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own fotos"
ON public.fotos
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own fotos"
ON public.fotos
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own fotos"
ON public.fotos
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own fotos"
ON public.fotos
FOR DELETE
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_fotos_updated_at
BEFORE UPDATE ON public.fotos
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 14 ====================
-- Create radiografias table
CREATE TABLE public.radiografias (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  titulo TEXT NOT NULL,
  imagem_base64 TEXT NOT NULL,
  tipo_exame TEXT,
  data_exame DATE,
  laudo TEXT,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.radiografias ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own radiografias"
ON public.radiografias
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own radiografias"
ON public.radiografias
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own radiografias"
ON public.radiografias
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own radiografias"
ON public.radiografias
FOR DELETE
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_radiografias_updated_at
BEFORE UPDATE ON public.radiografias
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 15 ====================
-- Create receituario table
CREATE TABLE public.receituario (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  data_prescricao DATE NOT NULL,
  medicamentos JSONB NOT NULL DEFAULT '[]'::jsonb,
  diagnostico TEXT,
  observacoes TEXT,
  validade DATE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.receituario ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own receituario"
ON public.receituario
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own receituario"
ON public.receituario
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own receituario"
ON public.receituario
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own receituario"
ON public.receituario
FOR DELETE
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_receituario_updated_at
BEFORE UPDATE ON public.receituario
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 16 ====================
-- Create sequence for ordem_servico number
CREATE SEQUENCE IF NOT EXISTS ordem_servico_numero_seq START 1;

-- Create ordem_servico table
CREATE TABLE public.ordem_servico (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  numero_os TEXT NOT NULL UNIQUE DEFAULT 'OS-' || to_char(nextval('ordem_servico_numero_seq'), 'FM000000'),
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE RESTRICT,
  dentista_id UUID NOT NULL REFERENCES public.dentistas(id) ON DELETE RESTRICT,
  data_abertura DATE NOT NULL DEFAULT CURRENT_DATE,
  data_prevista DATE,
  data_conclusao DATE,
  procedimentos JSONB NOT NULL DEFAULT '[]'::jsonb,
  valor_total NUMERIC(10, 2) DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'Aberta',
  prioridade TEXT DEFAULT 'Normal',
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.ordem_servico ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own ordem_servico"
ON public.ordem_servico
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own ordem_servico"
ON public.ordem_servico
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ordem_servico"
ON public.ordem_servico
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ordem_servico"
ON public.ordem_servico
FOR DELETE
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_ordem_servico_updated_at
BEFORE UPDATE ON public.ordem_servico
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create index for better query performance
CREATE INDEX idx_ordem_servico_paciente ON public.ordem_servico(paciente_id);
CREATE INDEX idx_ordem_servico_dentista ON public.ordem_servico(dentista_id);
CREATE INDEX idx_ordem_servico_status ON public.ordem_servico(status);

-- ==================== MIGRATION 17 ====================
-- Create honorarios table
CREATE TABLE public.honorarios (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  procedimento TEXT NOT NULL,
  codigo TEXT NOT NULL,
  categoria TEXT NOT NULL,
  valor_particular NUMERIC NOT NULL DEFAULT 0,
  valor_convenio NUMERIC NOT NULL DEFAULT 0,
  duracao_media INTEGER NOT NULL DEFAULT 30,
  status TEXT NOT NULL DEFAULT 'Ativo',
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.honorarios ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own honorarios" 
ON public.honorarios 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own honorarios" 
ON public.honorarios 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own honorarios" 
ON public.honorarios 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own honorarios" 
ON public.honorarios 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_honorarios_updated_at
BEFORE UPDATE ON public.honorarios
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 18 ====================
-- Create agendamentos table
CREATE TABLE public.agendamentos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  paciente_id UUID NOT NULL,
  dentista_id UUID NOT NULL,
  data_agendamento TIMESTAMP WITH TIME ZONE NOT NULL,
  duracao INTEGER NOT NULL DEFAULT 30,
  procedimento TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Agendado',
  tipo_atendimento TEXT NOT NULL DEFAULT 'Consulta',
  convenio_id UUID,
  valor NUMERIC,
  observacoes TEXT,
  confirmado BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.agendamentos ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own agendamentos" 
ON public.agendamentos 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own agendamentos" 
ON public.agendamentos 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own agendamentos" 
ON public.agendamentos 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own agendamentos" 
ON public.agendamentos 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_agendamentos_updated_at
BEFORE UPDATE ON public.agendamentos
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create index for better query performance
CREATE INDEX idx_agendamentos_data ON public.agendamentos(data_agendamento);
CREATE INDEX idx_agendamentos_paciente ON public.agendamentos(paciente_id);
CREATE INDEX idx_agendamentos_dentista ON public.agendamentos(dentista_id);

-- ==================== MIGRATION 19 ====================
-- Criar tabela de contas a pagar
CREATE TABLE public.contas_pagar (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  fornecedor_id UUID REFERENCES public.fornecedores(id),
  descricao TEXT NOT NULL,
  categoria TEXT NOT NULL,
  valor NUMERIC NOT NULL CHECK (valor > 0),
  data_vencimento DATE NOT NULL,
  data_pagamento DATE,
  status TEXT NOT NULL DEFAULT 'Pendente' CHECK (status IN ('Pendente', 'Paga', 'Vencida', 'Cancelada')),
  forma_pagamento TEXT,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Índices para melhor performance
CREATE INDEX idx_contas_pagar_user_id ON public.contas_pagar(user_id);
CREATE INDEX idx_contas_pagar_status ON public.contas_pagar(status);
CREATE INDEX idx_contas_pagar_data_vencimento ON public.contas_pagar(data_vencimento);
CREATE INDEX idx_contas_pagar_fornecedor_id ON public.contas_pagar(fornecedor_id);

-- Enable Row Level Security
ALTER TABLE public.contas_pagar ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own contas_pagar" 
ON public.contas_pagar 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own contas_pagar" 
ON public.contas_pagar 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own contas_pagar" 
ON public.contas_pagar 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own contas_pagar" 
ON public.contas_pagar 
FOR DELETE 
USING (auth.uid() = user_id);

-- Trigger para atualizar updated_at
CREATE TRIGGER update_contas_pagar_updated_at
BEFORE UPDATE ON public.contas_pagar
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger para atualizar status automaticamente quando vencida
CREATE OR REPLACE FUNCTION public.atualizar_status_contas_vencidas()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'Pendente' AND NEW.data_vencimento < CURRENT_DATE AND NEW.data_pagamento IS NULL THEN
    NEW.status = 'Vencida';
  END IF;
  
  IF NEW.data_pagamento IS NOT NULL AND NEW.status IN ('Pendente', 'Vencida') THEN
    NEW.status = 'Paga';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_status_contas_vencidas
BEFORE INSERT OR UPDATE ON public.contas_pagar
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_status_contas_vencidas();

-- ==================== MIGRATION 20 ====================
-- Corrigir search_path da função para segurança
CREATE OR REPLACE FUNCTION public.atualizar_status_contas_vencidas()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.status = 'Pendente' AND NEW.data_vencimento < CURRENT_DATE AND NEW.data_pagamento IS NULL THEN
    NEW.status = 'Vencida';
  END IF;
  
  IF NEW.data_pagamento IS NOT NULL AND NEW.status IN ('Pendente', 'Vencida') THEN
    NEW.status = 'Paga';
  END IF;
  
  RETURN NEW;
END;
$$;

-- ==================== MIGRATION 21 ====================
-- Create contas_receber table
CREATE TABLE IF NOT EXISTS public.contas_receber (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  paciente_id UUID,
  descricao TEXT NOT NULL,
  categoria TEXT NOT NULL,
  valor NUMERIC NOT NULL,
  data_vencimento DATE NOT NULL,
  data_recebimento DATE,
  status TEXT NOT NULL DEFAULT 'Pendente' CHECK (status IN ('Pendente', 'Recebida', 'Vencida', 'Cancelada')),
  forma_pagamento TEXT,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.contas_receber ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own contas_receber"
  ON public.contas_receber
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own contas_receber"
  ON public.contas_receber
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own contas_receber"
  ON public.contas_receber
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own contas_receber"
  ON public.contas_receber
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_contas_receber_user_id ON public.contas_receber(user_id);
CREATE INDEX idx_contas_receber_paciente_id ON public.contas_receber(paciente_id);
CREATE INDEX idx_contas_receber_status ON public.contas_receber(status);
CREATE INDEX idx_contas_receber_data_vencimento ON public.contas_receber(data_vencimento);

-- Create trigger for updated_at
CREATE TRIGGER update_contas_receber_updated_at
  BEFORE UPDATE ON public.contas_receber
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Create trigger to automatically update status
CREATE TRIGGER atualizar_status_contas_receber
  BEFORE INSERT OR UPDATE ON public.contas_receber
  FOR EACH ROW
  EXECUTE FUNCTION public.atualizar_status_contas_vencidas();

-- ==================== MIGRATION 22 ====================
-- Drop the incorrect trigger
DROP TRIGGER IF EXISTS atualizar_status_contas_receber ON public.contas_receber;

-- Create a new function specific for contas_receber
CREATE OR REPLACE FUNCTION public.atualizar_status_contas_receber_func()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
  IF NEW.status = 'Pendente' AND NEW.data_vencimento < CURRENT_DATE AND NEW.data_recebimento IS NULL THEN
    NEW.status = 'Vencida';
  END IF;
  
  IF NEW.data_recebimento IS NOT NULL AND NEW.status IN ('Pendente', 'Vencida') THEN
    NEW.status = 'Recebida';
  END IF;
  
  RETURN NEW;
END;
$function$;

-- Create the correct trigger
CREATE TRIGGER atualizar_status_contas_receber
  BEFORE INSERT OR UPDATE ON public.contas_receber
  FOR EACH ROW
  EXECUTE FUNCTION public.atualizar_status_contas_receber_func();

-- ==================== MIGRATION 23 ====================
-- Create fluxo_caixa table
CREATE TABLE IF NOT EXISTS public.fluxo_caixa (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('Entrada', 'Saída')),
  descricao TEXT NOT NULL,
  categoria TEXT NOT NULL,
  valor NUMERIC NOT NULL,
  data_movimentacao DATE NOT NULL,
  forma_pagamento TEXT,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.fluxo_caixa ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own fluxo_caixa"
  ON public.fluxo_caixa
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own fluxo_caixa"
  ON public.fluxo_caixa
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own fluxo_caixa"
  ON public.fluxo_caixa
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own fluxo_caixa"
  ON public.fluxo_caixa
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_fluxo_caixa_user_id ON public.fluxo_caixa(user_id);
CREATE INDEX idx_fluxo_caixa_tipo ON public.fluxo_caixa(tipo);
CREATE INDEX idx_fluxo_caixa_data_movimentacao ON public.fluxo_caixa(data_movimentacao);

-- Create trigger for updated_at
CREATE TRIGGER update_fluxo_caixa_updated_at
  BEFORE UPDATE ON public.fluxo_caixa
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 24 ====================
-- Create comissoes table
CREATE TABLE IF NOT EXISTS public.comissoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  dentista_id UUID NOT NULL,
  referencia TEXT NOT NULL,
  valor_total_procedimentos NUMERIC NOT NULL DEFAULT 0,
  percentual_comissao NUMERIC NOT NULL,
  valor_comissao NUMERIC NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'Pendente' CHECK (status IN ('Pendente', 'Paga', 'Cancelada')),
  data_pagamento DATE,
  forma_pagamento TEXT,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.comissoes ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own comissoes"
  ON public.comissoes
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own comissoes"
  ON public.comissoes
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own comissoes"
  ON public.comissoes
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comissoes"
  ON public.comissoes
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_comissoes_user_id ON public.comissoes(user_id);
CREATE INDEX idx_comissoes_dentista_id ON public.comissoes(dentista_id);
CREATE INDEX idx_comissoes_status ON public.comissoes(status);
CREATE INDEX idx_comissoes_data_inicio ON public.comissoes(data_inicio);
CREATE INDEX idx_comissoes_data_fim ON public.comissoes(data_fim);

-- Create trigger for updated_at
CREATE TRIGGER update_comissoes_updated_at
  BEFORE UPDATE ON public.comissoes
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 25 ====================
-- Create cheques table
CREATE TABLE IF NOT EXISTS public.cheques (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  numero_cheque TEXT NOT NULL,
  banco TEXT NOT NULL,
  agencia TEXT NOT NULL,
  conta TEXT NOT NULL,
  emitente TEXT NOT NULL,
  cpf_cnpj TEXT,
  valor NUMERIC NOT NULL,
  data_emissao DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  data_compensacao DATE,
  status TEXT NOT NULL DEFAULT 'A Compensar' CHECK (status IN ('A Compensar', 'Compensado', 'Devolvido', 'Cancelado')),
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.cheques ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own cheques"
  ON public.cheques
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own cheques"
  ON public.cheques
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cheques"
  ON public.cheques
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cheques"
  ON public.cheques
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_cheques_user_id ON public.cheques(user_id);
CREATE INDEX idx_cheques_status ON public.cheques(status);
CREATE INDEX idx_cheques_data_vencimento ON public.cheques(data_vencimento);
CREATE INDEX idx_cheques_numero_cheque ON public.cheques(numero_cheque);

-- Create trigger for updated_at
CREATE TRIGGER update_cheques_updated_at
  BEFORE UPDATE ON public.cheques
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 26 ====================
-- Criar tabela de manuais e códigos
CREATE TABLE public.manuais_codigos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('Manual', 'Código de Procedimento', 'Tabela', 'Documento')),
  titulo TEXT NOT NULL,
  codigo TEXT,
  descricao TEXT,
  categoria TEXT NOT NULL,
  conteudo TEXT,
  link_externo TEXT,
  arquivo_base64 TEXT,
  tags TEXT[],
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE public.manuais_codigos ENABLE ROW LEVEL SECURITY;

-- Políticas RLS
CREATE POLICY "Users can view their own manuais_codigos"
ON public.manuais_codigos
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own manuais_codigos"
ON public.manuais_codigos
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own manuais_codigos"
ON public.manuais_codigos
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own manuais_codigos"
ON public.manuais_codigos
FOR DELETE
USING (auth.uid() = user_id);

-- Trigger para updated_at
CREATE TRIGGER update_manuais_codigos_updated_at
BEFORE UPDATE ON public.manuais_codigos
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Índices para melhorar performance
CREATE INDEX idx_manuais_codigos_user_id ON public.manuais_codigos(user_id);
CREATE INDEX idx_manuais_codigos_tipo ON public.manuais_codigos(tipo);
CREATE INDEX idx_manuais_codigos_categoria ON public.manuais_codigos(categoria);
CREATE INDEX idx_manuais_codigos_tags ON public.manuais_codigos USING GIN(tags);

-- ==================== MIGRATION 27 ====================
-- Create contatos_uteis table
CREATE TABLE public.contatos_uteis (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  nome TEXT NOT NULL,
  telefone TEXT NOT NULL,
  categoria TEXT NOT NULL,
  tipo TEXT,
  email TEXT,
  endereco TEXT,
  horario_funcionamento TEXT,
  observacoes TEXT,
  status TEXT NOT NULL DEFAULT 'Ativo',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.contatos_uteis ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own contatos_uteis" 
ON public.contatos_uteis 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own contatos_uteis" 
ON public.contatos_uteis 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own contatos_uteis" 
ON public.contatos_uteis 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own contatos_uteis" 
ON public.contatos_uteis 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_contatos_uteis_updated_at
BEFORE UPDATE ON public.contatos_uteis
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 28 ====================
-- Create informacoes_clinica table
CREATE TABLE public.informacoes_clinica (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE,
  nome_clinica TEXT NOT NULL,
  cnpj TEXT,
  cro_clinica TEXT,
  telefone TEXT NOT NULL,
  celular TEXT,
  email TEXT NOT NULL,
  website TEXT,
  endereco TEXT NOT NULL,
  numero TEXT,
  complemento TEXT,
  bairro TEXT,
  cidade TEXT NOT NULL,
  estado TEXT NOT NULL,
  cep TEXT NOT NULL,
  horario_funcionamento JSONB DEFAULT '{"segunda": "", "terca": "", "quarta": "", "quinta": "", "sexta": "", "sabado": "", "domingo": ""}'::jsonb,
  logo_base64 TEXT,
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.informacoes_clinica ENABLE ROW LEVEL SECURITY;

-- Create policies for user access
CREATE POLICY "Users can view their own informacoes_clinica" 
ON public.informacoes_clinica 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own informacoes_clinica" 
ON public.informacoes_clinica 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own informacoes_clinica" 
ON public.informacoes_clinica 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own informacoes_clinica" 
ON public.informacoes_clinica 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_informacoes_clinica_updated_at
BEFORE UPDATE ON public.informacoes_clinica
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- ==================== MIGRATION 29 ====================
-- Remove horario_funcionamento column from informacoes_clinica table
ALTER TABLE public.informacoes_clinica DROP COLUMN IF EXISTS horario_funcionamento;

-- ==================== MIGRATION 30 ====================
-- Criar tabela de perfis de usuário
CREATE TABLE public.profiles (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE,
  nome_exibicao TEXT,
  telefone TEXT,
  foto_perfil_base64 TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Políticas RLS
CREATE POLICY "Users can view their own profile"
ON public.profiles
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile"
ON public.profiles
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile"
ON public.profiles
FOR UPDATE
USING (auth.uid() = user_id);

-- Trigger para atualizar updated_at
CREATE TRIGGER update_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Função para criar perfil automaticamente quando usuário se registra
CREATE OR REPLACE FUNCTION public.handle_new_user_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (user_id, nome_exibicao)
  VALUES (NEW.id, NEW.email);
  RETURN NEW;
END;
$$;

-- Trigger para criar perfil automaticamente
CREATE TRIGGER on_auth_user_created_profile
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user_profile();

-- ==================== MIGRATION 31 ====================
-- Criar tabela de configurações do sistema
CREATE TABLE public.configuracoes_sistema (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE,
  permitir_registro BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE public.configuracoes_sistema ENABLE ROW LEVEL SECURITY;

-- Políticas RLS
CREATE POLICY "Users can view their own configuracoes_sistema"
ON public.configuracoes_sistema
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own configuracoes_sistema"
ON public.configuracoes_sistema
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own configuracoes_sistema"
ON public.configuracoes_sistema
FOR UPDATE
USING (auth.uid() = user_id);

-- Trigger para atualizar updated_at
CREATE TRIGGER update_configuracoes_sistema_updated_at
BEFORE UPDATE ON public.configuracoes_sistema
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Inserir configuração padrão para usuários existentes
INSERT INTO public.configuracoes_sistema (user_id, permitir_registro)
SELECT id, true FROM auth.users
ON CONFLICT (user_id) DO NOTHING;

-- ==================== MIGRATION 32 ====================
-- Criar política para permitir leitura pública do campo permitir_registro
-- Isso é necessário para a tela de login verificar se o registro está habilitado
CREATE POLICY "Anyone can view permitir_registro setting"
ON public.configuracoes_sistema
FOR SELECT
TO anon
USING (true);

-- Comentário: Esta política permite que usuários não autenticados (anon) 
-- consultem a configuração de registro na tela de login

-- ==================== MIGRATION 33 ====================
-- Corrigir constraints problemáticas da tabela dentistas
-- Remove constraints muito restritivas que estão causando erro 400

-- Remover constraints problemáticas
ALTER TABLE public.dentistas DROP CONSTRAINT IF EXISTS check_cro_format;
ALTER TABLE public.dentistas DROP CONSTRAINT IF EXISTS check_cpf_format;

-- Adicionar constraints mais flexíveis
-- CRO pode ter formato "CRO-SP 12345" ou apenas números
ALTER TABLE public.dentistas ADD CONSTRAINT check_cro_not_empty 
CHECK (length(trim(cro)) > 0);

-- CPF pode ter formato "000.000.000-00" ou apenas números
ALTER TABLE public.dentistas ADD CONSTRAINT check_cpf_not_empty 
CHECK (length(trim(cpf)) > 0);

-- Adicionar constraint para email válido
ALTER TABLE public.dentistas ADD CONSTRAINT check_email_format 
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Adicionar constraint para telefone não vazio
ALTER TABLE public.dentistas ADD CONSTRAINT check_telefone_not_empty 
CHECK (length(trim(telefone)) > 0);

-- Adicionar constraint para nome não vazio
ALTER TABLE public.dentistas ADD CONSTRAINT check_nome_not_empty 
CHECK (length(trim(nome)) > 0);

-- ==================== MIGRATION 34 ====================
-- Criação da tabela horarios_disponiveis
CREATE TABLE public.horarios_disponiveis (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    dia_semana integer NOT NULL CHECK (dia_semana >= 0 AND dia_semana <= 6),
    hora time NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índices para melhor performance
CREATE INDEX idx_horarios_disponiveis_user_id ON public.horarios_disponiveis(user_id);
CREATE INDEX idx_horarios_disponiveis_dia_semana ON public.horarios_disponiveis(dia_semana);
CREATE INDEX idx_horarios_disponiveis_ativo ON public.horarios_disponiveis(ativo);

-- Índice único para evitar horários duplicados por usuário
CREATE UNIQUE INDEX idx_horarios_disponiveis_unique ON public.horarios_disponiveis(user_id, dia_semana, hora);

-- RLS (Row Level Security)
ALTER TABLE public.horarios_disponiveis ENABLE ROW LEVEL SECURITY;

-- Política para permitir que usuários vejam apenas seus próprios horários
CREATE POLICY "Users can view own horarios_disponiveis" ON public.horarios_disponiveis
    FOR SELECT USING (auth.uid() = user_id);

-- Política para permitir que usuários insiram seus próprios horários
CREATE POLICY "Users can insert own horarios_disponiveis" ON public.horarios_disponiveis
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Política para permitir que usuários atualizem seus próprios horários
CREATE POLICY "Users can update own horarios_disponiveis" ON public.horarios_disponiveis
    FOR UPDATE USING (auth.uid() = user_id);

-- Política para permitir que usuários deletem seus próprios horários
CREATE POLICY "Users can delete own horarios_disponiveis" ON public.horarios_disponiveis
    FOR DELETE USING (auth.uid() = user_id);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_horarios_disponiveis_updated_at
    BEFORE UPDATE ON public.horarios_disponiveis
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

