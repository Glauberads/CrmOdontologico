# 🦷 CRM Odonto — Sistema Odontológico

Plataforma moderna de gestão clínica, agendamento de consultas, prontuário eletrônico e controle financeiro odontológico.

---

## 🛠️ Tecnologias Utilizadas
- **TypeScript**
- **React**
- **Vite**
- **TailwindCSS**
- **Supabase** (PostgreSQL + Auth + RLS)

---

## 📦 Como Instalar e Rodar Localmente

### 1. Pré-requisitos
- **Node.js** 18.x ou 20.x+ instalado.
- Conta no **Supabase**.

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

### 4. Iniciar Servidor de Desenvolvimento
```bash
npm run dev
```
Acesse no seu navegador: `http://localhost:3000`.

---

## 🌐 Deploy em Produção (Vercel)
1. Conecte o repositório GitHub na Vercel.
2. Configure as variáveis de ambiente `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`.
3. O deploy é executado automaticamente a cada push na branch `main`.
