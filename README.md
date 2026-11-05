# 🚀 Inova — CRM Odontológico — Código-Fonte Completo & Deploy

> **Sistema Adquirido e Liberado via afCode**  
> Categoria: **SAAS** | Preço Oficial: **R$ 197.90**

---

## 🛠️ Tecnologias Utilizadas
- **TypeScript**
- **Vite**
- **Supabase**
- **PostgreSQL**

---

## 📦 Como Instalar e Rodar Localmente

### 1. Pré-requisitos
- **Node.js** 18.x ou 20.x LTS instalado.
- Conta gratuita no **[Supabase](https://supabase.com)**.

### 2. Instalação das Dependências
```bash
npm install
```

### 3. Configuração do Ambiente
Copie o arquivo de exemplo e preencha com suas chaves do Supabase:
```bash
cp .env.example .env
```

No arquivo `.env`:
```env
VITE_SUPABASE_URL=https://seu-id.supabase.co
VITE_SUPABASE_ANON_KEY=sua-chave-anon-aqui
```

### 4. Configuração do Banco de Dados (Supabase SQL)
1. Acesse o painel do seu projeto no Supabase.
2. Abra a aba **SQL Editor**.
3. Copie todo o conteúdo do arquivo `supabase/migrations/20260101_init.sql` e execute.
4. As tabelas com Row Level Security (RLS) estarão criadas imediatamente.

### 5. Iniciar Servidor de Desenvolvimento
```bash
npm run dev
```
Acesse no seu navegador: `http://localhost:3000`.

---

## 🌐 Deploy em Produção (Vercel ou Netlify)
1. Crie um repositório no seu GitHub e suba este código.
2. Na Vercel ou Netlify, selecione o repositório.
3. Configure as variáveis `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`.
4. Clique em **Deploy**.

---

© 2026 afCode — Todos os direitos de comercialização concedidos ao adquirente.
