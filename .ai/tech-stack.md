### Frontend
- **Astro 5:** Główny framework do budowy aplikacji. Posłuży do tworzenia zoptymalizowanych, renderowanych po stronie serwera stron oraz jako "powłoka" dla interaktywnych komponentów.
- **React 19:** Biblioteka do budowy dynamicznych i interaktywnych części interfejsu użytkownika (UI), takich jak dashboard, formularze czy tabele z danymi, które będą działać jako "wyspy" wewnątrz stron Astro.
- **TypeScript 5:** Język programowania, który doda statyczne typowanie do kodu JavaScript, zapewniając większe bezpieczeństwo, lepszą czytelność i łatwiejsze utrzymanie kodu.
- **Tailwind CSS 4:** Framework CSS typu utility-first, który posłuży do szybkiego i spójnego stylowania całej aplikacji bez pisania tradycyjnego CSS.
- **Shadcn/ui:** Zbiór gotowych, dostępnych i komponowalnych komponentów UI (np. przyciski, formularze, wykresy), który znacząco przyspieszy budowę interfejsu.

### Backend
- **Supabase:** Wystąpi w roli Backend-as-a-Service (BaaS). Zapewni gotową do użycia bazę danych PostgreSQL, system uwierzytelniania (logowanie e-mailem, przez Google/Facebook), automatycznie generowane API do komunikacji z bazą danych oraz bezpieczne zarządzanie dostępem do danych dzięki mechanizmowi Row-Level Security.

### AI
- **OpenRouter.ai:** Będzie bramą do komunikacji z różnymi modelami AI. Zostanie wykorzystany do implementacji kluczowych funkcji, takich jak automatyczne odczytywanie danych z faktur (OCR) oraz generowanie cotygodniowych, spersonalizowanych podsumowań i raportów finansowych dla użytkowników.

### Pipeline
- **Github Actions:** Narzędzie do automatyzacji procesów CI/CD (Continuous Integration/Continuous Deployment). Będzie odpowiedzialne za automatyczne budowanie, testowanie i wdrażanie aplikacji po każdej zmianie w kodzie.
- **Cloudflare Workers:** Platforma do hostingu i uruchamiania aplikacji. Zapewni globalne, wydajne i skalowalne serwowanie aplikacji użytkownikom końcowym bezpośrednio z sieci brzegowej (Edge).
