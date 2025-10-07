# Dokument wymagań produktu (PRD) - CashyFlow

## 1. Przegląd produktu

CashyFlow to aplikacja w modelu SaaS (Software as a Service) przeznaczona dla freelancerów, mikroprzedsiębiorstw i osób prowadzących jednoosobową działalność gospodarczą. Jej głównym celem jest dostarczenie użytkownikom klarownego i aktualnego obrazu ich sytuacji finansowej, koncentrując się na przepływach pieniężnych (cash flow), a nie na skomplikowanej księgowości podatkowej. Aplikacja umożliwia zarządzanie fakturami, prognozowanie wydatków i monitorowanie płynności finansowej w czasie rzeczywistym, pomagając podejmować lepsze decyzje biznesowe. Wersja MVP skupia się na kluczowych funkcjonalnościach, które dostarczą natychmiastową wartość i pozwolą na weryfikację rynkową produktu.

## 2. Problem użytkownika

Tradycyjne systemy księgowe są zoptymalizowane pod kątem rozliczeń podatkowych i wymogów prawnych. Choć doskonale radzą sobie z obliczaniem podatków i generowaniem oficjalnych dokumentów, nie dostarczają przedsiębiorcom intuicyjnej odpowiedzi na fundamentalne pytanie: "jaki jest rzeczywisty stan moich finansów i czy stać mnie na kolejne wydatki?". Użytkownicy z segmentu mikroprzedsiębiorstw często zmagają się z brakiem przejrzystego wglądu w swoje przepływy pieniężne. Nie wiedzą, jakie środki faktycznie wpłyną na ich konto w najbliższym czasie, jakie są nadchodzące zobowiązania i czy planowany wydatek nie zagrozi płynności finansowej firmy. Ręczne śledzenie tych danych w arkuszach kalkulacyjnych jest czasochłonne, podatne na błędy i nie daje dynamicznego obrazu sytuacji. CashyFlow ma za zadanie wypełnić tę lukę, stając się prostym narzędziem do zarządzania realną gotówką w firmie.

## 3. Wymagania funkcjonalne

- `FR-001: Zarządzanie fakturami:` Pełna obsługa operacji CRUD (Create, Read, Update, Delete) dla faktur sprzedaży i kosztowych.
- `FR-002: OCR faktur:` Możliwość dodawania faktur poprzez skan (OCR). System musi osiągnąć minimum 80% poprawności odczytu dla pól krytycznych (NIP, kwota brutto/netto, data sprzedaży). W przypadku niższej skuteczności, użytkownik jest kierowany do formularza w celu manualnej weryfikacji danych.
- `FR-003: Dashboard:` Główny panel aplikacji prezentujący dane w czasie rzeczywistym:
  - Aktualny stan gotówki.
  - Wykres prognozy przepływów pieniężnych na najbliższe 30 dni.
  - Lista nadchodzących płatności (koszty).
  - Lista oczekiwanych wpływów (sprzedaż).
- `FR-004: Zarządzanie kontem użytkownika:`
  - Rejestracja za pomocą adresu e-mail i hasła.
  - Rejestracja za pośrednictwem kont Google i Facebook (OAuth).
  - Logowanie do systemu.
  - Funkcjonalność resetowania hasła.
- `FR-005: Onboarding:` Proces wprowadzający nowego użytkownika, obejmujący jednorazowe wprowadzenie początkowego stanu gotówki oraz zachętę do dodania faktur z ostatnich 2 miesięcy w celu natychmiastowego zobaczenia wartości aplikacji.
- `FR-006: Śledzenie płatności:` Możliwość oznaczania statusu płatności dla każdej faktury (opłacona / nieopłacona).
- `FR-007: Oznaczanie kontrahentów:` System wizualnie oznaczy kontrahenta, który co najmniej dwukrotnie opóźnił się z płatnością w ciągu ostatnich 6 miesięcy. Przy nazwie kontrahenta wyświetlana będzie informacja o średniej liczbie dni opóźnienia.
- `FR-008: Prognozowanie wydatków:` Użytkownik może manualnie oznaczyć fakturę jako cykliczną. Dodatkowo, system AI będzie analizował historię i sugerował oznaczenie podobnych wydatków jako cykliczne.
- `FR-009: Przeliczanie walut:` Automatyczne przeliczanie wartości faktur wystawionych w obcych walutach na PLN z wykorzystaniem publicznego API NBP (kurs z dnia wystawienia i dnia płatności). W przypadku niedostępności API, użytkownik będzie miał możliwość ręcznego wprowadzenia kursu.
- `FR-010: Raporty AI:` Cotygodniowe, automatycznie generowane podsumowania finansowe (przychody, koszty, przepływ netto, prognoza) wysyłane na adres e-mail użytkownika. W aplikacji dostępne będzie archiwum historycznych raportów.
- `FR-011: Kategoryzacja:` Prosty system tagowania lub kategoryzacji dla kosztów i przychodów, z możliwością zarządzania (dodawanie, edycja, usuwanie) kategoriami przez użytkownika.

## 4. Granice produktu

Poniższe funkcjonalności celowo nie wchodzą w zakres wersji MVP (Minimum Viable Product), aby umożliwić szybkie dostarczenie wartości i zebranie opinii od pierwszych użytkowników:

- Obsługa wielu firm w ramach jednego konta użytkownika.
- Integracja z Krajowym Systemem e-Faktur (KSeF).
- Integracje z systemami bankowymi w celu automatycznego importu transakcji.
- Integracje z API zewnętrznych programów księgowych.
- Funkcjonalność eksportu danych do formatów CSV lub XLSX.

## 5. Historyjki użytkowników

### Zarządzanie kontem

- `ID:` US-001
- `Tytuł:` Rejestracja użytkownika za pomocą adresu e-mail
- `Opis:` Jako nowy użytkownik, chcę móc założyć konto w aplikacji, podając swój adres e-mail i ustawiając hasło, aby uzyskać dostęp do systemu.
- `Kryteria akceptacji:`

  1.  Formularz rejestracji zawiera pola: adres e-mail, hasło, powtórz hasło.
  2.  System waliduje poprawność formatu adresu e-mail.
  3.  System sprawdza, czy hasła w obu polach są identyczne.
  4.  System wymaga hasła o minimalnej sile (np. 8 znaków, duża litera, cyfra).
  5.  Po pomyślnej rejestracji użytkownik jest automatycznie zalogowany i przekierowany do procesu onboardingu.
  6.  Użytkownik nie może zarejestrować się na e-mail, który już istnieje w systemie.

- `ID:` US-002
- `Tytuł:` Logowanie użytkownika za pomocą adresu e-mail
- `Opis:` Jako zarejestrowany użytkownik, chcę móc zalogować się do aplikacji przy użyciu mojego adresu e-mail i hasła, aby uzyskać dostęp do moich danych.
- `Kryteria akceptacji:`

  1.  Formularz logowania zawiera pola: adres e-mail, hasło.
  2.  Po poprawnym wprowadzeniu danych użytkownik zostaje zalogowany i przekierowany do dashboardu.
  3.  W przypadku błędnych danych, wyświetlany jest stosowny komunikat.

- `ID:` US-003
- `Tytuł:` Rejestracja i logowanie za pomocą konta Google
- `Opis:` Jako nowy lub powracający użytkownik, chcę móc zarejestrować się lub zalogować za pomocą mojego konta Google, aby przyspieszyć proces i nie musieć pamiętać kolejnego hasła.
- `Kryteria akceptacji:`

  1.  Na stronie logowania/rejestracji znajduje się przycisk "Zaloguj się z Google".
  2.  Po kliknięciu użytkownik jest przekierowywany do standardowego okna uwierzytelniania Google.
  3.  Po pomyślnym uwierzytelnieniu, jeśli użytkownik nie istnieje, tworzone jest nowe konto.
  4.  Użytkownik jest zalogowany i przekierowany do aplikacji (do onboardingu dla nowych, do dashboardu dla powracających).

- `ID:` US-004
- `Tytuł:` Rejestracja i logowanie za pomocą konta Facebook
- `Opis:` Jako nowy lub powracający użytkownik, chcę móc zarejestrować się lub zalogować za pomocą mojego konta Facebook, aby uprościć proces dostępu do aplikacji.
- `Kryteria akceptacji:`

  1.  Na stronie logowania/rejestracji znajduje się przycisk "Zaloguj się z Facebook".
  2.  Po kliknięciu użytkownik jest przekierowywany do standardowego okna uwierzytelniania Facebook.
  3.  Po pomyślnym uwierzytelnieniu, jeśli użytkownik nie istnieje, tworzone jest nowe konto.
  4.  Użytkownik jest zalogowany i przekierowany do aplikacji.

- `ID:` US-005
- `Tytuł:` Resetowanie hasła
- `Opis:` Jako zarejestrowany użytkownik, który zapomniał hasła, chcę mieć możliwość jego zresetowania, aby odzyskać dostęp do mojego konta.
- `Kryteria akceptacji:`

  1.  Na stronie logowania znajduje się link "Zapomniałem hasła".
  2.  Po kliknięciu i podaniu adresu e-mail, na który zarejestrowane jest konto, system wysyła wiadomość z unikalnym linkiem do resetowania hasła.
  3.  Link jest ważny przez określony czas (np. 1 godzinę).
  4.  Po przejściu pod link, użytkownik może ustawić nowe hasło (zgodnie z polityką siły hasła).

- `ID:` US-006
- `Tytuł:` Wylogowanie z systemu
- `Opis:` Jako zalogowany użytkownik, chcę móc się wylogować z aplikacji, aby zabezpieczyć swoje dane.
- `Kryteria akceptacji:`
  1.  W interfejsie aplikacji znajduje się widoczny przycisk "Wyloguj".
  2.  Po kliknięciu sesja użytkownika jest kończona i zostaje on przekierowany na stronę logowania.

### Onboarding

- `ID:` US-007
- `Tytuł:` Wprowadzenie początkowego stanu gotówki
- `Opis:` Jako nowy użytkownik, podczas pierwszego uruchomienia aplikacji, chcę wprowadzić mój aktualny stan gotówki (środki dostępne w firmie), aby stanowił on punkt wyjścia dla wszystkich analiz przepływów pieniężnych.
- `Kryteria akceptacji:`

  1.  Pierwszym krokiem onboardingu jest prośba o podanie początkowego stanu gotówki.
  2.  Wprowadzona wartość jest zapisywana i staje się bazą dla "Aktualnego stanu gotówki" na dashboardzie.
  3.  Użytkownik może pominąć ten krok i uzupełnić dane później w ustawieniach.

- `ID:` US-008
- `Tytuł:` Dodawanie danych historycznych podczas onboardingu
- `Opis:` Jako nowy użytkownik, po wprowadzeniu stanu gotówki, chcę być zachęcony do dodania faktur z ostatnich 2 miesięcy, aby natychmiast zobaczyć, jak dashboard i prognozy wypełniają się danymi i pokazują wartość aplikacji.
- `Kryteria akceptacji:`
  1.  Po kroku z stanem gotówki, aplikacja wyświetla ekran zachęcający do dodania faktur.
  2.  Użytkownik ma możliwość dodawania faktur ręcznie lub przez OCR.
  3.  W tle lub obok formularza widoczny jest dashboard, który aktualizuje się w czasie rzeczywistym po dodaniu każdej faktury.
  4.  Użytkownik może pominąć ten krok.

### Zarządzanie fakturami

- `ID:` US-009
- `Tytuł:` Ręczne dodawanie faktury kosztowej
- `Opis:` Jako użytkownik, chcę móc ręcznie dodać nową fakturę kosztową, wypełniając prosty formularz, aby uwzględnić ją w moich finansach.
- `Kryteria akceptacji:`

  1.  Formularz zawiera minimalny zestaw pól: Nazwa kontrahenta, NIP kontrahenta, numer faktury, kwota netto, kwota brutto, data wystawienia, termin płatności.
  2.  Po zapisaniu faktura pojawia się na liście faktur i jest uwzględniana w dashboardzie.
  3.  System automatycznie zapisuje dane kontrahenta do późniejszego wykorzystania.

- `ID:` US-010
- `Tytuł:` Ręczne dodawanie faktury sprzedaży
- `Opis:` Jako użytkownik, chcę móc ręcznie dodać nową fakturę sprzedaży, aby śledzić nadchodzące wpływy.
- `Kryteria akceptacji:`

  1.  Formularz zawiera minimalny zestaw pól: Nazwa kontrahenta, NIP kontrahenta, numer faktury, "Pozycja z faktury" (jako pojedyncze pole tekstowe opisujące usługę/produkt), kwota netto, kwota brutto, data wystawienia, termin płatności.
  2.  Po zapisaniu faktura pojawia się na liście faktur i jest uwzględniana w prognozach wpływów.

- `ID:` US-011
- `Tytuł:` Dodawanie faktury za pomocą OCR
- `Opis:` Jako użytkownik, chcę móc przesłać plik (np. PDF, JPG) z fakturą, aby system automatycznie odczytał z niego dane i wypełnił formularz, oszczędzając mój czas.
- `Kryteria akceptacji:`

  1.  Użytkownik może przesłać plik z fakturą.
  2.  System przetwarza plik i próbuje odczytać kluczowe pola (NIP, kwota brutto/netto, data sprzedaży, numer faktury, dane kontrahenta).
  3.  Jeśli odczyt pól krytycznych jest powyżej 80% pewności, dane są prezentowane użytkownikowi do zatwierdzenia.
  4.  Po zatwierdzeniu faktura jest dodawana do systemu.

- `ID:` US-012
- `Tytuł:` Ręczna weryfikacja danych z OCR
- `Opis:` Jako użytkownik, jeśli system OCR nie odczytał danych z faktury z wystarczającą pewnością, chcę zostać przekierowany do formularza z częściowo wypełnionymi danymi i obrazem faktury, aby szybko je zweryfikować i poprawić.
- `Kryteria akceptacji:`

  1.  Gdy pewność odczytu OCR jest poniżej 80% dla pól krytycznych, użytkownik jest przenoszony do widoku weryfikacji.
  2.  Widok zawiera formularz z polami wypełnionymi przez OCR oraz podgląd oryginalnego dokumentu.
  3.  Użytkownik może ręcznie poprawić lub uzupełnić dane.
  4.  Po zatwierdzeniu faktura jest dodawana do systemu.

- `ID:` US-013
- `Tytuł:` Przeglądanie listy faktur
- `Opis:` Jako użytkownik, chcę mieć dostęp do listy wszystkich moich faktur (kosztowych i sprzedażowych), aby móc je przeglądać, sortować i filtrować.
- `Kryteria akceptacji:`

  1.  Aplikacja wyświetla listę wszystkich dodanych faktur.
  2.  Lista pokazuje kluczowe informacje: numer faktury, kontrahenta, kwotę, datę wystawienia, termin płatności i status płatności.
  3.  Użytkownik może filtrować listę (np. po typie faktury, statusie płatności, kontrahencie).
  4.  Użytkownik może sortować listę (np. po dacie, kwocie).

- `ID:` US-014
- `Tytuł:` Edycja istniejącej faktury
- `Opis:` Jako użytkownik, chcę móc edytować dane wcześniej wprowadzonej faktury, aby poprawić ewentualne błędy.
- `Kryteria akceptacji:`

  1.  Z poziomu listy faktur lub szczegółów faktury można przejść do trybu edycji.
  2.  Formularz edycji pozwala na zmianę wszystkich pól faktury.
  3.  Po zapisaniu zmian dane w systemie oraz na dashboardzie są aktualizowane.

- `ID:` US-015
- `Tytuł:` Usuwanie faktury
- `Opis:` Jako użytkownik, chcę mieć możliwość usunięcia błędnie dodanej faktury.
- `Kryteria akceptacji:`

  1.  Użytkownik może usunąć fakturę.
  2.  Przed usunięciem wyświetlane jest okno z prośbą o potwierdzenie operacji.
  3.  Po usunięciu faktura znika z systemu, a dashboard i prognozy są przeliczane na nowo.

- `ID:` US-016
- `Tytuł:` Zmiana statusu płatności faktury
- `Opis:` Jako użytkownik, chcę móc oznaczyć fakturę jako "opłaconą" lub "nieopłaconą", aby poprawnie śledzić przepływy pieniężne.
- `Kryteria akceptacji:`

  1.  Na liście faktur lub w jej szczegółach znajduje się opcja zmiany statusu płatności.
  2.  Zmiana statusu faktury kosztowej na "opłacona" zmniejsza "Aktualny stan gotówki".
  3.  Zmiana statusu faktury sprzedaży na "opłacona" zwiększa "Aktualny stan gotówki".
  4.  Data zmiany statusu jest zapisywana jako data płatności.

- `ID:` US-017
- `Tytuł:` Dodawanie faktury w obcej walucie
- `Opis:` Jako użytkownik, chcę móc dodać fakturę wystawioną w obcej walucie, a system powinien automatycznie przeliczyć jej wartość na PLN.
- `Kryteria akceptacji:`

  1.  W formularzu faktury można wybrać walutę (domyślnie PLN).
  2.  Po wybraniu obcej waluty i wprowadzeniu kwoty, system pobiera kurs z API NBP na dzień wystawienia faktury i wyświetla przeliczoną wartość w PLN.
  3.  Po oznaczeniu faktury jako opłaconej, system pobiera kurs z dnia płatności i na tej podstawie aktualizuje stan gotówki.
  4.  Obie wartości (oryginalna i przeliczona) są widoczne w szczegółach faktury.

- `ID:` US-018
- `Tytuł:` Obsługa niedostępności API NBP
- `Opis:` Jako użytkownik, w przypadku gdy API NBP do kursów walut jest niedostępne, chcę mieć możliwość ręcznego wprowadzenia kursu, aby móc dodać fakturę w obcej walucie.
- `Kryteria akceptacji:`

  1.  Gdy system nie może połączyć się z API NBP, przy polu kwoty pojawia się dodatkowe pole do ręcznego wpisania kursu waluty.
  2.  Użytkownik jest informowany o problemie z API.
  3.  Obliczenia są wykonywane na podstawie kursu wprowadzonego przez użytkownika.

- `ID:` US-019
- `Tytuł:` Oznaczanie faktury jako cyklicznej
- `Opis:` Jako użytkownik, chcę móc oznaczyć fakturę (np. za abonament) jako cykliczną, aby system uwzględniał ją w przyszłych prognozach finansowych.
- `Kryteria akceptacji:`

  1.  W formularzu faktury znajduje się opcja "faktura cykliczna" z możliwością wyboru częstotliwości (np. co miesiąc, co kwartał, co rok).
  2.  Po oznaczeniu, system automatycznie tworzy prognozowane przyszłe płatności w dashboardzie na podstawie tej faktury.

- `ID:` US-020
- `Tytuł:` Sugestia AI dotycząca faktur cyklicznych
- `Opis:` Jako użytkownik, po dodaniu faktury podobnej do poprzednich (ten sam kontrahent, podobna kwota), chcę otrzymać od systemu sugestię, czy oznaczyć ten wydatek jako cykliczny, aby ułatwić prognozowanie.
- `Kryteria akceptacji:`

  1.  Po zapisaniu faktury, która pasuje do wzorca wydatków cyklicznych, system wyświetla pytanie, czy użytkownik chce ją oznaczyć jako cykliczną.
  2.  Użytkownik może zaakceptować sugestię lub ją odrzucić.

- `ID:` US-021
- `Tytuł:` Kategoryzowanie faktury
- `Opis:` Jako użytkownik, dodając lub edytując fakturę, chcę móc przypisać jej kategorię (tag), aby później móc analizować strukturę moich kosztów i przychodów.
- `Kryteria akceptacji:`

  1.  W formularzu faktury znajduje się pole do wyboru lub dodania nowej kategorii.
  2.  Użytkownik może przypisać jedną lub więcej kategorii do faktury.

- `ID:` US-022
- `Tytuł:` Zarządzanie kategoriami
- `Opis:` Jako użytkownik, chcę mieć dostęp do panelu zarządzania kategoriami, gdzie mogę dodawać nowe, edytować istniejące i usuwać nieużywane kategorie.
- `Kryteria akceptacji:`
  1.  W ustawieniach aplikacji znajduje się sekcja "Kategorie".
  2.  Użytkownik może tworzyć nowe kategorie, podając ich nazwę.
  3.  Użytkownik może zmieniać nazwy istniejących kategorii.
  4.  Użytkownik może usuwać kategorie. Usunięcie kategorii powoduje jej odpięcie od wszystkich powiązanych faktur.

### Dashboard i Raportowanie

- `ID:` US-023
- `Tytuł:` Przeglądanie głównego dashboardu
- `Opis:` Jako zalogowany użytkownik, chcę widzieć główny dashboard z kluczowymi informacjami finansowymi, aby szybko ocenić kondycję mojej firmy.
- `Kryteria akceptacji:`

  1.  Dashboard jest domyślnym widokiem po zalogowaniu.
  2.  Na dashboardzie widoczne są:
      a. Aktualny stan gotówki.
      b. Wykres prognozy przepływów pieniężnych na 30 dni.
      c. Lista najbliższych oczekiwanych wpływów (nieopłacone faktury sprzedaży).
      d. Lista najbliższych zaplanowanych wydatków (nieopłacone faktury kosztowe).
  3.  Wszystkie dane na dashboardzie aktualizują się w czasie rzeczywistym po każdej operacji na fakturach.

- `ID:` US-024
- `Tytuł:` Otrzymywanie cotygodniowego raportu e-mail
- `Opis:` Jako użytkownik, chcę co tydzień otrzymywać na mój adres e-mail podsumowanie finansowe, aby być na bieżąco z moimi finansami bez konieczności codziennego logowania się.
- `Kryteria akceptacji:`

  1.  Raz w tygodniu system automatycznie generuje i wysyła raport e-mailowy.
  2.  Raport zawiera podsumowanie kluczowych metryk z ostatniego tygodnia: przychody, koszty, przepływ netto.
  3.  E-mail zawiera link zachęcający do zalogowania się i zobaczenia pełnego raportu.

- `ID:` US-025
- `Tytuł:` Przeglądanie archiwum raportów AI
- `Opis:` Jako użytkownik, chcę mieć w aplikacji dostęp do archiwum wszystkich historycznych cotygodniowych raportów, aby móc analizować trendy w czasie.
- `Kryteria akceptacji:`
  1.  W aplikacji istnieje sekcja "Raporty".
  2.  W tej sekcji znajduje się lista wszystkich wygenerowanych dotąd raportów tygodniowych.
  3.  Kliknięcie na raport pozwala zobaczyć jego szczegółowe dane.

### Zarządzanie Kontrahentami

- `ID:` US-026
- `Tytuł:` Wizualne oznaczanie nieterminowych kontrahentów
- `Opis:` Jako użytkownik, przeglądając listę faktur lub kontrahentów, chcę widzieć specjalne oznaczenie przy tych, którzy notorycznie płacą z opóźnieniem, aby móc podjąć odpowiednie działania.
- `Kryteria akceptacji:`
  1.  Kontrahent, który miał co najmniej dwie opóźnione płatności w ciągu ostatnich 6 miesięcy, jest oznaczony wizualnie (np. czerwoną flagą).
  2.  Przy nazwie oflagowanego kontrahenta wyświetlana jest informacja o średniej liczbie dni opóźnienia.
  3.  Status jest dynamicznie przeliczany po każdej zmianie statusu płatności faktury.

### Ustawienia

- `ID:` US-027
- `Tytuł:` Edycja początkowego stanu gotówki
- `Opis:` Jako użytkownik, chcę mieć możliwość zmiany wprowadzonego podczas onboardingu początkowego stanu gotówki, aby skorygować ewentualny błąd lub zaktualizować go do bieżącej sytuacji.
- `Kryteria akceptacji:`
  1.  W ustawieniach konta znajduje się pole pozwalające na edycję "Początkowego stanu gotówki".
  2.  Zmiana tej wartości powoduje przeliczenie "Aktualnego stanu gotówki" na dashboardzie.

## 6. Metryki sukcesu

- `Aktywność użytkowników:` Osiągnięcie progu 10-20 aktywnych firm, które przez minimum jeden miesiąc wprowadzają i zarządzają swoimi realnymi danymi finansowymi. "Aktywny użytkownik" definiowany jest jako osoba, która dodaje co najmniej jedną fakturę tygodniowo.
- `Retencja:` 50% nowo zarejestrowanych użytkowników loguje się do aplikacji ponownie w ciągu 7 dni od rejestracji.
- `Opinie i referencje:` Zebranie co najmniej dwóch pozytywnych, publicznych opinii od użytkowników, które potwierdzają wartość produktu i mogą być wykorzystane w materiałach marketingowych.
