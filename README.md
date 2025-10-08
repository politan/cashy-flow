# CashyFlow

[![Project Status: In Development](https://img.shields.io/badge/status-in%20development-yellowgreen.svg)](https://github.com/politan/cashy-flow)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A SaaS application for freelancers and micro-enterprises to provide a clear, real-time view of their financial situation, focusing on cash flow rather than complex tax accounting.

## Table of Contents

- [Project Description](#project-description)
- [Tech Stack](#tech-stack)
- [Getting Started Locally](#getting-started-locally)
- [Available Scripts](#available-scripts)
- [Project Scope](#project-scope)
- [Project Status](#project-status)
- [License](#license)

## Project Description

CashyFlow is designed to solve a fundamental problem for small business owners: the lack of a clear, intuitive understanding of their real-time cash flow. Traditional accounting software is often complex and tax-oriented, failing to answer the simple question: "What is the actual state of my finances, and can I afford this new expense?"

This application provides tools for managing invoices, forecasting expenses, and monitoring financial liquidity in real-time, helping users make better business decisions. The MVP is focused on delivering immediate value by concentrating on core cash flow management features.

## Tech Stack

### Frontend

- **[Astro 5](https://astro.build/)**: Main framework for building server-rendered pages.
- **[React 19](https://react.dev/)**: For dynamic and interactive UI components (Islands).
- **[TypeScript 5](https://www.typescriptlang.org/)**: For static typing and improved code quality.
- **[Tailwind CSS 4](https://tailwindcss.com/)**: Utility-first CSS framework for styling.
- **[Shadcn/ui](https://ui.shadcn.com/)**: Collection of accessible and composable UI components.

### Backend

- **[Supabase](https://supabase.io/)**: Backend-as-a-Service providing a PostgreSQL database, authentication, auto-generated APIs, and Row-Level Security.

### AI

- **[OpenRouter.ai](https://openrouter.ai/)**: Gateway to various AI models for features like invoice OCR and generating weekly financial summaries.

### CI/CD & Hosting

- **[GitHub Actions](https://github.com/features/actions)**: For continuous integration and deployment automation.
- **[Cloudflare Workers](https://workers.cloudflare.com/)**: For hosting and serving the application from the edge.

## Getting Started Locally

### Prerequisites

- **Node.js**: Version `22.18.0` (as specified in the `.nvmrc` file). We recommend using [nvm](https://github.com/nvm-sh/nvm) to manage Node.js versions.
- **pnpm**: We recommend using `pnpm` as the package manager.

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/politan/cashy-flow.git
   cd cashy-flow
   ```

2. **Set up Node.js version:**

   If you are using `nvm`, run the following command to use the correct Node.js version:

   ```bash
   nvm use
   ```

3. **Install dependencies:**

   ```bash
   pnpm install
   ```

4. **Set up environment variables:**

   You will need to set up a Supabase project to run the backend.
   Create a `.env` file in the root of the project by copying the example file:

   ```bash
   cp .env.example .env
   ```

   Then, fill in the required environment variables in the `.env` file with your Supabase project URL and anon key. You will also need credentials for OpenRouter.ai.

5. **Run the development server:**

   ```bash
   pnpm dev
   ```

   The application will be available at `http://localhost:4321`.

## Available Scripts

In the project directory, you can run the following scripts:

- `pnpm dev`: Runs the app in development mode.
- `pnpm build`: Builds the app for production.
- `pnpm preview`: Runs a local server to preview the production build.
- `pnpm lint`: Lints the code using ESLint.
- `pnpm lint:fix`: Lints and automatically fixes issues.
- `pnpm format`: Formats the code using Prettier.

## Project Scope

### Key Features (MVP)

- **Invoice Management**: Full CRUD operations for sales and expense invoices.
- **Invoice OCR**: Add invoices by scanning them, with manual verification for low-confidence scans.
- **Dashboard**: Real-time view of cash status, 30-day cash flow forecast, upcoming payments, and expected income.
- **User Authentication**: Sign-up and login with email/password and OAuth (Google, Facebook).
- **Onboarding**: A simple process to set the initial cash balance and add historical data.
- **Payment Tracking**: Mark invoices as paid or unpaid.
- **Contractor Flagging**: Visually identify contractors who consistently pay late.
- **Expense Forecasting**: Mark invoices as recurring and get AI-based suggestions for recurring expenses.
- **Currency Conversion**: Automatic currency conversion for foreign invoices using the NBP API.
- **AI-Powered Reports**: Weekly email summaries of financial activity.
- **Categorization**: Simple tagging system for income and expenses.

### Out of Scope (for MVP)

- Multi-company support within a single user account.
- Integration with the Polish National e-Invoicing System (KSeF).
- Direct integration with bank APIs for automatic transaction imports.
- Integrations with external accounting software.
- Data export to CSV or XLSX formats.

## Project Status

This project is currently **in development**. The focus is on delivering the Minimum Viable Product (MVP) with the core features listed above.

## License

This project is licensed under the MIT License. See the `LICENSE.md` file for details.
