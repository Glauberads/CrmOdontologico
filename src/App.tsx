import { useState } from 'react';
import { CheckCircle, ExternalLink } from 'lucide-react';

export default function App() {
  const [activeTab, setActiveTab] = useState<'operacao' | 'banco' | 'deploy'>('operacao');

  return (
    <div style={{ minHeight: '100vh', background: '#090a0f', color: '#f8fafc', fontFamily: 'sans-serif' }}>
      {/* Top Header */}
      <header style={{ borderBottom: '1px solid #1e293b', padding: '16px 32px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: 'rgba(15, 23, 42, 0.6)', backdropFilter: 'blur(8px)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 36, height: 36, borderRadius: 8, background: '#00f2fe', color: '#090a0f', fontWeight: 'bold', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            af
          </div>
          <div>
            <h1 style={{ fontSize: 18, fontWeight: 700, margin: 0 }}>Inova — CRM Odontológico</h1>
            <span style={{ fontSize: 11, color: '#10b981' }}>✓ Código-Fonte 100% Liberado & Operacional</span>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 10 }}>
          <button onClick={() => setActiveTab('operacao')} style={{ padding: '8px 16px', background: activeTab === 'operacao' ? '#00f2fe' : '#1e293b', color: activeTab === 'operacao' ? '#090a0f' : '#fff', border: 'none', borderRadius: 6, fontWeight: 600, cursor: 'pointer' }}>
            Painel da Aplicação
          </button>
          <button onClick={() => setActiveTab('banco')} style={{ padding: '8px 16px', background: activeTab === 'banco' ? '#00f2fe' : '#1e293b', color: activeTab === 'banco' ? '#090a0f' : '#fff', border: 'none', borderRadius: 6, fontWeight: 600, cursor: 'pointer' }}>
            Banco Supabase
          </button>
          <button onClick={() => setActiveTab('deploy')} style={{ padding: '8px 16px', background: activeTab === 'deploy' ? '#00f2fe' : '#1e293b', color: activeTab === 'deploy' ? '#090a0f' : '#fff', border: 'none', borderRadius: 6, fontWeight: 600, cursor: 'pointer' }}>
            Guia de Deploy
          </button>
        </div>
      </header>

      {/* Main Content Area */}
      <main style={{ maxWidth: 1100, margin: '40px auto', padding: '0 24px' }}>
        {activeTab === 'operacao' && (
          <div style={{ background: '#0f172a', border: '1px solid #1e293b', borderRadius: 12, padding: 32 }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 24, borderBottom: '1px solid #1e293b', paddingBottom: 16 }}>
              <div>
                <h2 style={{ fontSize: 24, fontWeight: 700, margin: 0, color: '#00f2fe' }}>Inova — CRM Odontológico</h2>
                <p style={{ color: '#94a3b8', margin: '6px 0 0' }}>Inova — CRM Odontológico - Sistema pronto com codigo-fonte completo para personalizar e colocar em operacao.</p>
              </div>
              <a href="https://inova.afcode.com.br/" target="_blank" rel="noopener noreferrer" style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '10px 18px', background: 'rgba(16, 185, 129, 0.15)', border: '1px solid rgba(16, 185, 129, 0.4)', color: '#34d399', borderRadius: 8, textDecoration: 'none', fontWeight: 600 }}>
                Testar Demo ao Vivo <ExternalLink size={16} />
              </a>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: 20, marginBottom: 32 }}>
              <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid #1e293b', borderRadius: 10, padding: 20 }}>
                <span style={{ fontSize: 12, color: '#94a3b8' }}>Tecnologias</span>
                <div style={{ fontSize: 16, fontWeight: 700, marginTop: 4, color: '#38bdf8' }}>TypeScript • Vite • Supabase</div>
              </div>
              <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid #1e293b', borderRadius: 10, padding: 20 }}>
                <span style={{ fontSize: 12, color: '#94a3b8' }}>Autenticação</span>
                <div style={{ fontSize: 16, fontWeight: 700, marginTop: 4, color: '#10b981' }}>Supabase Auth + RLS</div>
              </div>
              <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid #1e293b', borderRadius: 10, padding: 20 }}>
                <span style={{ fontSize: 12, color: '#94a3b8' }}>Status da Licença</span>
                <div style={{ fontSize: 16, fontWeight: 700, marginTop: 4, color: '#a855f7' }}>Perpétua / Comercial</div>
              </div>
            </div>

            <h3 style={{ fontSize: 18, marginBottom: 16 }}>Recursos Inclusos no Projeto:</h3>
            <ul style={{ listStyle: 'none', padding: 0, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1' }}><CheckCircle size={18} color="#00f2fe" /> Frontend React + Vite totalmente modular</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#cbd5e1' }}><CheckCircle size={18} color="#00f2fe" /> Esquema PostgreSQL com políticas de RLS ativadas</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#00f2fe' }}><CheckCircle size={18} color="#00f2fe" /> Painel de administração com gráficos e métricas</li>
              <li style={{ display: 'flex', alignItems: 'center', gap: 10, color: '#00f2fe' }}><CheckCircle size={18} color="#00f2fe" /> Pronto para deploy na Vercel, Netlify ou VPS</li>
            </ul>
          </div>
        )}

        {activeTab === 'banco' && (
          <div style={{ background: '#0f172a', border: '1px solid #1e293b', borderRadius: 12, padding: 32 }}>
            <h2 style={{ fontSize: 20, marginBottom: 12 }}>Esquema SQL do Supabase</h2>
            <p style={{ color: '#94a3b8', fontSize: 14, marginBottom: 20 }}>
              Copie o script abaixo e execute no <strong>SQL Editor</strong> do seu painel do Supabase para criar as tabelas e políticas de segurança:
            </p>
            <pre style={{ background: '#020617', padding: 20, borderRadius: 8, overflowX: 'auto', fontSize: 13, border: '1px solid #1e293b', color: '#a5f3fc' }}>
              <code>{`-- Script de migração Supabase para Inova — CRM Odontológico
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE public.inova-crm-odontol-gico_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'ativo',
    metadata JSONB DEFAULT '{}'::jsonb,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

ALTER TABLE public.inova-crm-odontol-gico_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuários acessam apenas seus próprios dados"
    ON public.inova-crm-odontol-gico_items FOR ALL
    USING (auth.uid() = user_id);
`}</code>
            </pre>
          </div>
        )}

        {activeTab === 'deploy' && (
          <div style={{ background: '#0f172a', border: '1px solid #1e293b', borderRadius: 12, padding: 32 }}>
            <h2 style={{ fontSize: 20, marginBottom: 16 }}>Instruções de Instalação e Deploy</h2>
            <ol style={{ paddingLeft: 20, lineHeight: 1.8, color: '#cbd5e1' }}>
              <li>Execute <code>npm install</code> no terminal da pasta do projeto.</li>
              <li>Configure o arquivo <code>.env</code> com suas credenciais do Supabase.</li>
              <li>Execute <code>npm run dev</code> para rodar o ambiente local em <code>http://localhost:3000</code>.</li>
              <li>Para subir na Vercel ou Netlify, conecte seu GitHub e adicione as variáveis de ambiente.</li>
            </ol>
          </div>
        )}
      </main>
    </div>
  );
}
