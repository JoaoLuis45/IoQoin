// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsInfoTitle => 'About this screen';

  @override
  String get settingsInfoDescription =>
      'Here you can customize the app appearance and choose your preferred language.';

  @override
  String get loginTitle => 'Login';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get loginSubtitle => 'Sign in to continue managing your finances';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'I forgot my password';

  @override
  String get loginButton => 'Login';

  @override
  String get createAccountText => 'Don\'t have an account?';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get expenses => 'Expenses';

  @override
  String get income => 'Income';

  @override
  String get currentEnvironment => 'Current Environment';

  @override
  String get selectEnvironment => 'Select an environment';

  @override
  String get balance => 'Balance';

  @override
  String get viewModeTip =>
      'View mode: you cannot add transactions in past months.';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get currentTag => 'Current';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Start organizing your finances now';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Your full name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Type again';

  @override
  String get registerButton => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get nameRequired => 'Enter your name';

  @override
  String get nameMinLength => 'Name too short';

  @override
  String get confirmPasswordRequired => 'Confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get myEnvironmentsTitle => 'My Environments';

  @override
  String get generatingId => 'Generating ID...';

  @override
  String get tagCopied => 'Tag copied to clipboard!';

  @override
  String get errorLoadingEnvironments => 'Error loading environments';

  @override
  String get yourEnvironmentsSection => 'Your Environments';

  @override
  String get defaultTag => 'Default';

  @override
  String get sharedTag => 'Shared';

  @override
  String get inviteTooltip => 'Invite';

  @override
  String get leaveTooltip => 'Leave Environment';

  @override
  String get howItWorksTitle => 'How Environments work?';

  @override
  String get howItWorksDescription =>
      'Environments are isolated spaces to organize your finances separately.';

  @override
  String get personalEnvironment =>
      'Personal: your daily expenses and investments.';

  @override
  String get workEnvironment => 'Work: professional income and expenses.';

  @override
  String get travelEnvironment => 'Travel: budgets for your adventures.';

  @override
  String get inviteUserTitle => 'Invite User';

  @override
  String inviteUserMessage(String envName) {
    return 'Invite someone to join the environment \"$envName\". Enter the user TAG (e.g. #12345).';
  }

  @override
  String get userTagLabel => 'User Tag';

  @override
  String get cancel => 'Cancel';

  @override
  String get send => 'Send';

  @override
  String get inviteSentSuccess => 'Invite sent successfully!';

  @override
  String get pendingInvitesTitle => 'Pending Invites';

  @override
  String get noPendingInvites => 'No pending invites.';

  @override
  String invitedBy(String userName) {
    return 'Invited by: $userName';
  }

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get leaveEnvironmentTitle => 'Leave Environment';

  @override
  String leaveEnvironmentMessage(String envName) {
    return 'Are you sure you want to leave the environment \"$envName\"? You will lose access to all shared data.';
  }

  @override
  String get leaveSuccess => 'You left the environment successfully.';

  @override
  String get leaveError => 'Error leaving environment.';

  @override
  String get leaveButton => 'Leave';

  @override
  String get newEnvironmentTitle => 'New Environment';

  @override
  String get editEnvironmentTitle => 'Edit Environment';

  @override
  String get deleteEnvironmentTitle => 'Delete Environment';

  @override
  String get deleteEnvironmentMessage =>
      'Are you sure? This will not delete associated transactions for now (they will be inaccessible).';

  @override
  String get environmentNameLabel => 'Environment Name';

  @override
  String get environmentNameRequired => 'Enter a name';

  @override
  String get colorLabel => 'Color';

  @override
  String get iconLabel => 'Icon';

  @override
  String get setAsDefault => 'Set as default';

  @override
  String get createEnvironmentButton => 'CREATE ENVIRONMENT';

  @override
  String get saveChangesButton => 'SAVE CHANGES';

  @override
  String saveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email to receive a password reset link.';

  @override
  String get resetPasswordError => 'Error sending email. Check the address.';

  @override
  String get sendLinkButton => 'Send Link';

  @override
  String get emailSentTitle => 'Email Sent!';

  @override
  String get emailSentMessage =>
      'Check your inbox (and spam) to reset your password.';

  @override
  String get gotIt => 'Got it';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get addExpenseTitle => 'Add Expense';

  @override
  String get addIncomeTitle => 'Add Income';

  @override
  String get fixedTransactionsTitle => 'Fixed Transactions (Fast Fill)';

  @override
  String get amountLabel => 'Amount';

  @override
  String get quickValuesTitle => 'Quick Values';

  @override
  String get categoryLabel => 'Category';

  @override
  String get selectCategoryError => 'Select a category';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String get createCategoriesFirst =>
      'Create categories first in \"Categories\"';

  @override
  String get descriptionOptionalLabel => 'Description (optional)';

  @override
  String get descriptionHint => 'Ex: Supermarket shopping';

  @override
  String get dateLabel => 'Date';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get invalidAmountError => 'Enter a valid amount';

  @override
  String get expenseAddedSuccess => 'Expense added successfully!';

  @override
  String get incomeAddedSuccess => 'Income added successfully!';

  @override
  String get addTransactionError => 'Error adding. Try again.';

  @override
  String get myGoalsTitle => 'My Goals';

  @override
  String get goalsSubtitle => 'Set goals and track your progress';

  @override
  String goalsLoadError(String error) {
    return 'Error loading goals: $error';
  }

  @override
  String get noGoalsTitle => 'No goals defined';

  @override
  String get noGoalsMessage => 'Create goals to save\nand reach your dreams';

  @override
  String get createGoalButton => 'Create goal';

  @override
  String get userUnidentifiedError => 'Error: User not identified';

  @override
  String get addValueTitle => 'Add value';

  @override
  String get valueLabel => 'Value (\$)';

  @override
  String get addButton => 'Add';

  @override
  String get deleteGoalTitle => 'Delete goal';

  @override
  String deleteGoalMessage(String goalName) {
    return 'Do you want to delete \"$goalName\"?';
  }

  @override
  String get newGoalTitle => 'New Goal';

  @override
  String get goalNameLabel => 'Goal Name';

  @override
  String get goalNameHint => 'Ex: Viagem para praia';

  @override
  String get goalNameRequired => 'Digite um nome';

  @override
  String get targetAmountLabel => 'Valor alvo';

  @override
  String get targetAmountRequired => 'Enter an amount';

  @override
  String get deadlineDateLabel => 'Data limite';

  @override
  String daysRemaining(int days) {
    return '$days days';
  }

  @override
  String createGoalError(Object error) {
    return 'Error creating goal: $error';
  }

  @override
  String get goalCreatedSuccess => 'Goal created successfully!';

  @override
  String get goalCompletedStatus => 'Completed!';

  @override
  String get goalOverdueStatus => 'Overdue';

  @override
  String daysRemainingSuffix(int days) {
    return '$days days remaining';
  }

  @override
  String get goalProgressOf => 'of';

  @override
  String get deleteTransactionTitle => 'Delete transaction';

  @override
  String get deleteTransactionMessage =>
      'Are you sure you want to delete this transaction?';

  @override
  String get deleteButton => 'Delete';

  @override
  String get filterLabel => 'Filter';

  @override
  String get fixedLabel => 'Fixed';

  @override
  String get adjustFiltersTip => 'Try adjusting the filters';

  @override
  String get tapToAddTip => 'Tap + to add';

  @override
  String get viewOnlyLabel => 'View only';

  @override
  String get yourExpensesTitle => 'Your expenses';

  @override
  String get yourIncomeTitle => 'Your income';

  @override
  String get noExpenseFound => 'No expense found';

  @override
  String get noIncomeFound => 'No income found';

  @override
  String get noExpenseRegistered => 'No expense registered';

  @override
  String get noIncomeRegistered => 'No income registered';

  @override
  String get noExpenseThisMonth => 'No expense this month';

  @override
  String get noIncomeThisMonth => 'No income this month';

  @override
  String get filterExpensesTitle => 'Filter Expenses';

  @override
  String get filterIncomeTitle => 'Filter Income';

  @override
  String get cleanFilters => 'Clear';

  @override
  String get periodLabel => 'Period';

  @override
  String get dateFrom => 'From';

  @override
  String get dateTo => 'To';

  @override
  String get minLabel => 'Minimum';

  @override
  String get maxLabel => 'Maximum';

  @override
  String get categoriesLabel => 'Categorias';

  @override
  String get noCategoriesFound => 'Nenhuma categoria encontrada.';

  @override
  String get applyFiltersButton => 'Aplicar Filtros';

  @override
  String get expenseCategoriesTitle => 'Expense Categories';

  @override
  String get incomeCategoriesTitle => 'Income Categories';

  @override
  String get newCategoryTitle => 'New Category';

  @override
  String get categoryNameHint => 'Category Name';

  @override
  String get selectIconLabel => 'Select Icon';

  @override
  String get addCategoryButton => 'Add Category';

  @override
  String get yourCategoriesTitle => 'Your Categories';

  @override
  String get noCategoriesCreated => 'No categories created';

  @override
  String get addCategoriesAboveTip => 'Add categories above to get started';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String deleteCategoryMessage(String name) {
    return 'Do you want to delete \"$name\"?';
  }

  @override
  String get enterCategoryNameError => 'Enter a category name';

  @override
  String get categoryAddedSuccess => 'Category added!';

  @override
  String get addCategoryError => 'Error adding category';

  @override
  String get enterValidValue => 'Por favor, digite um valor válido';

  @override
  String get templateSavedSuccess => 'Template salvo com sucesso!';

  @override
  String get saveErrorMessage =>
      'Erro ao salvar. Verifique sua conexão ou permissões.';

  @override
  String get fixedExpensesTitle => 'Despesas Fixas';

  @override
  String get fixedIncomeTitle => 'Receitas Fixas';

  @override
  String get manageTemplatesSubtitle =>
      'Gerencie seus modelos de preenchimento';

  @override
  String get createNewFixedButton => 'Criar Nova Fixa';

  @override
  String get loadError => 'Erro ao carregar dados';

  @override
  String get permissionOrIndexError =>
      'Isso pode ser falta de permissão ou índice no Firebase.';

  @override
  String get noTemplatesFound => 'Sem modelos salvos';

  @override
  String get createTemplatesTip =>
      'Crie templates para agilizar o lançamento de contas recorrentes como aluguel, salário, etc.';

  @override
  String get deleteTemplateTitle => 'Excluir?';

  @override
  String get deleteTemplateMessage => 'Deseja remover este modelo?';

  @override
  String get templateRemoved => 'Modelo removido';

  @override
  String get defaultAmountLabel => 'Valor Padrão';

  @override
  String get saveTemplateButton => 'Salvar Template';

  @override
  String get drawerMyProfile => 'My Profile';

  @override
  String get drawerHelp => 'Help';

  @override
  String get drawerAbout => 'About';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerLogout => 'Logout';

  @override
  String get drawerLogoutConfirmTitle => 'Confirmar Saída';

  @override
  String get drawerLogoutConfirmMessage =>
      'Tem certeza que deseja desconectar sua conta?';

  @override
  String get drawerVersion => 'Version 1.0.0';

  @override
  String get notificationsTitle => 'Notifications Center';

  @override
  String notificationsUnread(int count) {
    return '$count unread';
  }

  @override
  String get notificationsAllRead => 'All read';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmptyTitle => 'All caught up';

  @override
  String get notificationsEmptyMessage =>
      'You have no new notifications at the moment.';

  @override
  String get notificationsConnectionError => 'Connection Error';

  @override
  String get notificationsErrorHint =>
      'Check if the Firebase index is created.';

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileTagLabel => 'My Tag';

  @override
  String get profileTagCopied => 'Tag copied to clipboard!';

  @override
  String get profileGeneratingId => 'Gerando ID...';

  @override
  String get profileNameLabel => 'Full Name';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profilePhoneHint => 'Adicione seu telefone';

  @override
  String get profileBirthDateLabel => 'Birth Date';

  @override
  String get profileGenderLabel => 'Gender';

  @override
  String get profileGenderSelect => 'Select gender';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderOther => 'Other';

  @override
  String get profileGenderPreferNotToSay => 'Prefer not to say';

  @override
  String get profileSaveButton => 'Save Changes';

  @override
  String get profileDeleteAccountTitle => 'Delete Account';

  @override
  String get profileDeleteAccountSubtitle => 'Permanently remove your data';

  @override
  String get profileLogoutTitle => 'Logout';

  @override
  String get profileLogoutSubtitle => 'End session on this device';

  @override
  String get profilePhotoGallery => 'Gallery';

  @override
  String get profilePhotoCamera => 'Camera';

  @override
  String get profilePhotoUpdated => 'Profile photo updated successfully!';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get profileDeleteConfirmMessage =>
      'This action is irreversible. All your data will be lost. Do you want to continue?';

  @override
  String get subscriptionsTitle => 'My Subscriptions';

  @override
  String get subscriptionsSubtitle => 'Track your recurring expenses';

  @override
  String get subscriptionsTotalMonthly => 'Monthly Total';

  @override
  String subscriptionsActiveCount(int count) {
    return '$count active';
  }

  @override
  String get subscriptionsEmptyTitle => 'No subscriptions registered';

  @override
  String get subscriptionsEmptyMessage =>
      'Add your subscriptions\nto track expenses';

  @override
  String get subscriptionsAddButton => 'Add Subscription';

  @override
  String get subscriptionsDeleteTitle => 'Delete Subscription';

  @override
  String subscriptionsDeleteMessage(String name) {
    return 'Do you want to delete \"$name\"?';
  }

  @override
  String get newSubscriptionTitle => 'New Subscription';

  @override
  String get subscriptionNameLabel => 'Subscription Name';

  @override
  String get subscriptionNameHint => 'Ex: Netflix, Spotify';

  @override
  String get subscriptionNameRequired => 'Enter a name';

  @override
  String get subscriptionFrequencyLabel => 'Frequency';

  @override
  String get subscriptionBillingDayLabel => 'Billing Day';

  @override
  String get subscriptionIconLabel => 'Icon';

  @override
  String get subscriptionAddedSuccess => 'Subscription added!';

  @override
  String get dashboardTitle => 'Dashboards';

  @override
  String get dashboardMonthlyOverview => 'Monthly Overview';

  @override
  String get dashboardExpenseByCategory => 'Expenses by Category';

  @override
  String get dashboardIncomeByCategory => 'Income by Category';

  @override
  String get dashboardNoData => 'No data to display';

  @override
  String get dashboardTouchDetails => 'Touch to see details';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutDescriptionTitle => 'Your complete tool for';

  @override
  String get aboutDescriptionSubtitle => 'personal financial management';

  @override
  String get aboutDescriptionBody =>
      'Control your income, expenses, and reach your financial goals in a simple and intuitive way.';

  @override
  String get aboutFeatureExpenses => 'Income & Expenses';

  @override
  String get aboutFeatureExpensesDesc =>
      'Register and categorize your transactions';

  @override
  String get aboutFeatureGoals => 'Goals';

  @override
  String get aboutFeatureGoalsDesc => 'Set savings and investment goals';

  @override
  String get aboutFeatureSubscriptions => 'Subscriptions';

  @override
  String get aboutFeatureSubscriptionsDesc =>
      'Track your recurring subscriptions';

  @override
  String get aboutCopyright => '© 2026 iQoin. All rights reserved.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesTabExpenses => 'Expenses';

  @override
  String get categoriesTabIncome => 'Income';

  @override
  String get categoriesNewCategory => 'New Category';

  @override
  String get categoriesEditCategory => 'Edit Category';

  @override
  String get categoriesHistoryTip => 'Touch a category to see history';

  @override
  String get categoriesLoadError => 'Error loading categories';

  @override
  String get categoriesEmpty => 'No categories found';

  @override
  String get categoriesDeleteTitle => 'Delete Category?';

  @override
  String get categoriesDeleteMessage =>
      'This will not delete existing transactions.';

  @override
  String categoriesDeleted(String name) {
    return 'Category \"$name\" deleted';
  }

  @override
  String get categoriesNameHint => 'Category Name';

  @override
  String get categoriesSaveButton => 'Save Changes';

  @override
  String get categoriesAddButton => 'Add';

  @override
  String get helpTitle => 'Help & FAQ';

  @override
  String get helpHeaderTitle => 'How can we help?';

  @override
  String get helpHeaderSubtitle => 'Check the frequently asked questions below';

  @override
  String get helpContactTitle => 'Still have questions?';

  @override
  String get helpContactSubtitle => 'Contact support';

  @override
  String get helpWhatsappButton => 'Contact us on WhatsApp';

  @override
  String get helpWhatsappError => 'Could not open WhatsApp';

  @override
  String get helpFaq1Question => 'How do I add a new transaction?';

  @override
  String get helpFaq1Answer =>
      'On the home screen, tap the \"Expenses\" or \"Income\" tab and use the \"+\" button in the bottom right corner. Fill in the details and save.';

  @override
  String get helpFaq2Question => 'Can I edit a transaction?';

  @override
  String get helpFaq2Answer =>
      'Currently, to ensure data integrity, we recommend deleting the incorrect transaction (swipe left) and creating a new one.';

  @override
  String get helpFaq3Question => 'How do Goals work?';

  @override
  String get helpFaq3Answer =>
      'In the \"Goals\" tab, you can create financial goals (e.g., Travel, Car). Set a target amount and add savings progressively to visually track your progress.';

  @override
  String get helpFaq4Question => 'What are Subscriptions?';

  @override
  String get helpFaq4Answer =>
      'The \"Subscriptions\" tab is used to list your recurring expenses (Netflix, Spotify, Gym). This helps visualize how much of your monthly budget is already committed.';

  @override
  String get helpFaq5Question => 'Is my data safe?';

  @override
  String get helpFaq5Answer =>
      'Yes! Your data is stored in the Google cloud (Firebase) with secure authentication. Only you have access to your information.';

  @override
  String get helpFaq6Question => 'How do I change my password?';

  @override
  String get helpFaq6Answer =>
      'Go to the side menu, tap \"Profile\" and select the \"Change Password\" option. A reset email will be sent to you.';

  @override
  String get tabDashboard => 'Dash';

  @override
  String get tabGoals => 'Goals';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCategories => 'Categ.';

  @override
  String get tabSubscriptions => 'Subs.';

  @override
  String get settingsReplayTutorial => 'Replay Tutorial';

  @override
  String get onboardingTitle1 => 'Track your expenses';

  @override
  String get onboardingDesc1 =>
      'Take full control of your finances with detailed charts and custom categories.';

  @override
  String get onboardingTitle2 => 'Set smart goals';

  @override
  String get onboardingDesc2 =>
      'Achieve your dreams by creating goals and tracking your progress month by month.';

  @override
  String get onboardingTitle3 => 'Subscriptions & Alerts';

  @override
  String get onboardingDesc3 =>
      'Manage your recurring services and get reminders before due dates.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get close => 'Close';
}
