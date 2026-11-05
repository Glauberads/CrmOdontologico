import { useState } from 'react';
import { CheckCircle, Activity, ShieldCheck, Sparkles, Database, Layers, ArrowRight } from 'lucide-react';

export default function App() {
  const [activeTab, setActiveTab] = useState<'operacao' | 'banco' | 'deploy'>('operacao');

  return (
    <div style={{ minHeight: '100vh', background: '#090a0f', color: '#f8fafc', fontFamily: 'sans-serif' }}>
      {/* Top Header */}
      <header style={{ borderBottom: '1px solid #1e293b', padding: '16px 32px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: 'rgba(15, 23, 42, 0.6)', backdropFilter: 'blur(8px)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 40, height: 40, borderRadius: 10, background: 'linear-gradient(135deg, #00f2fe 0%, #4facfe 100%)', color: '#090a0f', fontWeight: 'bold', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 16 }}>
            🦷
          </div>
          <div>
            <h1 style={{ fontSize: 18, fontWeight: 700, margin: 0, letterSpacing: '-0.02em' }}>CRM Odonto</h1>
            <span style={{ fontSize: 11, color: '#10b981', fontWeight: 600 }}>✓ Sistema Odontológico Operacional</span>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 10 }}>
          <button 
            onClick={() => setActiveTab('operacao')} 
            style={{ padding: '8px 16px', background: activeTab === 'operacao' ? '#00f2fe' : '#1e293b', color: activeTab === 'operacao' ? '#090a0f' : '#fff', border: 'none', borderRadius: 8, fontWeight: 600, cursor: 'pointer', transition: 'all 0.2s' }}>
            Painel da Aplicação
          </button>
          <button 
            onClick={() => setActiveTab('banco')} 
            style={{ padding: '8px 16px', background: activeTab === 'banco' ? '#00f2fe' : '#1e293b', color: activeTab === 'banco' ? '#090a0f' : '#fff', border: 'none', borderRadius: 8, fontWeight: 600, cursor: 'pointer', transition: 'all 0.2s' }}>
            Banco Supabase
          </button>
          <button 
            onClick={() => setActiveTab('deploy')} 
            style={{ padding: '8px 16px', background: activeTab === 'deploy' ? '#00f2fe' : '#1e293b', color: activeTab === 'deploy' ? '#090a0f' : '#fff', border: 'none', borderRadius: 8, fontWeight: 600, cursor: 'pointer', transition: 'all 0.2s' }}>
            Guia de Deploy
          </button>
        </div>
      </header>

      {/* Main Content Area */}
      <main style={{ maxWidth: 1100, margin: '40px auto', padding: '0 24px' }}>
        {activeTab === 'operacao' && (
          <div style={{ background: '#0f172a', border: '1px solid #1e293b', borderRadius: 16, padding: 36, boxShadow: '0 20px 40px rgba(0,0,0,0.4)' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 28, borderBottom: '1px solid #1e293b', paddingBottom: 20 }}>
              <div>
                <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, padding: '4px 10px', background: 'rgba(0, 242, 254, 0.1)', color: '#00f2fe', borderRadius: 20, fontSize: 12, fontWeight: 600, marginBottom: 8 }}>
                  <Sparkles size={14} /> CRM Odonto v1.0
                </div>
                <h2 style={{ fontSize: 28, fontWeight: 800, margin: 0, color: '#f8fafc', letterSpacing: '-0.02em' }}>CRM Odonto</h2>
                <p style={{ color: '#94a3b8', margin: '8px 0 0', fontSize: 15 }}>Plataforma completa de gestão clínica, agendamento de pacientes, prontuário e controle financeiro odontológico.</p>
              </div>
              <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '10px 18px', background: 'rgba(16, 185, 129, 0.15)', border: '1px solid rgba(16, 185, 129, 0.4)', color: '#34d399', borderRadius: 8, fontWeight: 600, fontSize: 14 }}>
                <Activity size={16} /> Sistema Ativo
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: 20, marginBottom: 32 }}>
              <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid #1e293b', borderRadius: 12, padding: 20 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#94a3b8', fontSize: 12, fontWeight: 600 }}>
                  <Layers size={14} /> TECNOLOGIAS
                </div>
                <div style={{ fontSize: 16, fontWeight: 700, marginTop: 6, color: '#38bdf8' }}>TypeScript • Vite • React</div>
              </div>
              <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid #1e293b', borderRadius: 12, padding: 20 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#94a3b8', fontSize: 12, fontWeight: 600 }}>
                  <Database size={14} /> BANCO DE DADOS
                </div>
                <div style={{ fontSize: 16, fontWeight: 700, marginTop: 6, color: '#10b981' }}>Supabase PostgreSQL + RLS</div>
              </div>
              <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid #1e293b', borderRadius: 12, padding: 20 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#94a3b8', fontSize: 12, fontWeight: 600 }}>
                  <ShieldCheck size={14} /> SEGURANÇA
                </div>
                <div style={{ fontSize: 16, fontWeight: 700, marginTop: 6, color: '#a855f7' }}>Row Level Security Isolado</div>
              </div>
            </div>

            <h3 style={{ fontSize: 18, fontWeight: 700, marginBottom: 16, color: '#f8fafc' }}>Módulos e Recursos do CRM Odonto:</h3>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: 14 }}>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1', fontSize: 14 }}><CheckCircle size={18} color="#00f2fe" /> Gestão de Pacientes e Prontuários Eletrônicos</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1', fontSize: 14 }}><CheckCircle size={18} color="#00f2fe" /> Agenda de Consultas e Ocupação de Cadeiras</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1', fontSize: 14 }}><CheckCircle size={18} color="#00f2fe" /> Módulo Financeiro, Fluxo de Caixa e Comissões</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1', fontSize: 14 }}><CheckCircle size={18} color="#00f2fe" /> Cadastro de Dentistas, Especialidades e Estoque</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1', fontSize: 14 }}><CheckCircle size={18} color="#00f2fe" /> Painel com Indicadores e Metas de Produção em Tempo Real</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1', fontSize: 14 }}><CheckCircle size={18} color="#00f2fe" /> Banco de dados em nuvem conectado via Supabase</li>
            </ul>
          </div>
        )}

        {activeTab === 'banco' && (
          <div style={{ background: '#0f172a', border: '1px solid #1e293b', borderRadius: 16, padding: 36 }}>
            <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 8, color: '#00f2fe' }}>Esquema SQL do Supabase</h2>
            <p style={{ color: '#94a3b8', fontSize: 14, marginBottom: 20 }}>
              Execute o script abaixo no <strong>SQL Editor</strong> do seu painel do Supabase para criar as tabelas e políticas de segurança:
            </p>
            <pre style={{ background: '#020617', padding: 22, borderRadius: 10, overflowX: 'auto', fontSize: 13, border: '1px solid #1e293b', color: '#a5f3fc', lineHeight: 1.6 }}>
              <code>{`-- Script de banco de dados para CRM Odonto
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

CREATE TABLE IF NOT EXISTS public.crm_odonto_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    payment_method VARCHAR(50) DEFAULT 'pix',
    payment_status VARCHAR(50) DEFAULT 'approved',
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

ALTER TABLE public.crm_odonto_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crm_odonto_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura e escrita de dados proprios" ON public.crm_odonto_records
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Transacoes acessadas apenas pelo dono" ON public.crm_odonto_transactions
    FOR ALL USING (auth.uid() = user_id);
`}</code>
            </pre>
          </div>
        )}

        {activeTab === 'deploy' && (
          <div style={{ background: '#0f172a', border: '1px solid #1e293b', borderRadius: 16, padding: 36 }}>
            <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 12, color: '#00f2fe' }}>Configuração e Deploy do CRM Odonto</h2>
            <ol style={{ paddingLeft: 20, lineHeight: 2, color: '#cbd5e1', fontSize: 15 }}>
              <li>Clone o repositório: <code>git clone https://github.com/Glauberads/CrmOdontologico.git</code></li>
              <li>Instale as dependências: <code>npm install</code></li>
              <li>Configure o arquivo <code>.env</code> com suas credenciais do Supabase.</li>
              <li>Inicie o servidor de desenvolvimento: <code>npm run dev</code></li>
              <li>Deploy em produção conectado à Vercel na branch <code>main</code>.</li>
            </ol>
          </div>
        )}
      </main>
    </div>
  );
}
