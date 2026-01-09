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
  String get forgotPassword => 'Forgot my password';

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
  String get howItWorksTitle => 'How Environments Work?';

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
  String inviteUserMessage(Object envName) {
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
  String invitedBy(Object userName) {
    return 'Invited by: $userName';
  }

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get leaveEnvironmentTitle => 'Leave Environment';

  @override
  String leaveEnvironmentMessage(Object envName) {
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
  String get setAsDefault => 'Set as Default';

  @override
  String get createEnvironmentButton => 'CREATE ENVIRONMENT';

  @override
  String get saveChangesButton => 'SAVE CHANGES';

  @override
  String saveError(Object error) {
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
  String get fixedTransactionsTitle => 'Fixed Transactions (Quick Fill)';

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
  String get descriptionOptionalLabel => 'Description (Optional)';

  @override
  String get descriptionHint => 'Ex: Groceries';

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
  String goalsLoadError(Object error) {
    return 'Error loading goals: $error';
  }

  @override
  String get noGoalsTitle => 'No goals defined';

  @override
  String get noGoalsMessage => 'Create goals to save\nand achieve your dreams';

  @override
  String get createGoalButton => 'Create goal';

  @override
  String get userUnidentifiedError => 'Error: User unidentified';

  @override
  String get addValueTitle => 'Add value';

  @override
  String get valueLabel => 'Value';

  @override
  String get addButton => 'Add';

  @override
  String get deleteGoalTitle => 'Delete goal';

  @override
  String deleteGoalMessage(Object goalName) {
    return 'Do you want to delete \"$goalName\"?';
  }

  @override
  String get newGoalTitle => 'New Goal';

  @override
  String get goalNameLabel => 'Goal Name';

  @override
  String get goalNameHint => 'Ex: Beach Trip';

  @override
  String get goalNameRequired => 'Enter a name';

  @override
  String get targetAmountLabel => 'Target Amount';

  @override
  String get targetAmountRequired => 'Enter an amount';

  @override
  String get deadlineDateLabel => 'Deadline Date';

  @override
  String daysRemaining(Object days) {
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
  String daysRemainingSuffix(Object days) {
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
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get noCategoriesFound => 'No categories found.';

  @override
  String get applyFiltersButton => 'Apply Filters';

  @override
  String get expenseCategoriesTitle => 'Expense Categories';

  @override
  String get incomeCategoriesTitle => 'Income Categories';

  @override
  String get newCategoryTitle => 'New Category';

  @override
  String get categoryNameHint => 'Category Name';

  @override
  String get selectIconLabel => 'Select an icon';

  @override
  String get addCategoryButton => 'Add Category';

  @override
  String get yourCategoriesTitle => 'Your Categories';

  @override
  String get noCategoriesCreated => 'No categories created';

  @override
  String get addCategoriesAboveTip => 'Add categories above';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String deleteCategoryMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get enterCategoryNameError => 'Enter category name';

  @override
  String get categoryAddedSuccess => 'Category added!';

  @override
  String get addCategoryError => 'Error adding category';

  @override
  String get enterValidValue => 'Please enter a valid amount';

  @override
  String get templateSavedSuccess => 'Template saved successfully!';

  @override
  String get saveErrorMessage =>
      'Error saving. Check your connection or permissions.';

  @override
  String get fixedExpensesTitle => 'Fixed Expenses';

  @override
  String get fixedIncomeTitle => 'Fixed Income';

  @override
  String get manageTemplatesSubtitle => 'Manage your transaction templates';

  @override
  String get createNewFixedButton => 'Create New Fixed';

  @override
  String get loadError => 'Error loading data';

  @override
  String get permissionOrIndexError =>
      'This might be missing permission or index in Firebase.';

  @override
  String get noTemplatesFound => 'No templates saved';

  @override
  String get createTemplatesTip =>
      'Create templates to speed up recurring bills like rent, salary, etc.';

  @override
  String get deleteTemplateTitle => 'Delete?';

  @override
  String get deleteTemplateMessage => 'Do you want to remove this template?';

  @override
  String get templateRemoved => 'Template removed';

  @override
  String get defaultAmountLabel => 'Default Amount';

  @override
  String get saveTemplateButton => 'Save Template';

  @override
  String get drawerMyProfile => 'My Profile';

  @override
  String get drawerHelp => 'Help';

  @override
  String get drawerAbout => 'About iQoin';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerLogout => 'Log Out';

  @override
  String get drawerLogoutConfirmTitle => 'Confirm Logout';

  @override
  String get drawerLogoutConfirmMessage =>
      'Are you sure you want to disconnect your account?';

  @override
  String get drawerVersion => 'Version';

  @override
  String get notificationsTitle => 'Notification Center';

  @override
  String notificationsUnread(Object count) {
    return '$count unread';
  }

  @override
  String get notificationsAllRead => 'All read';

  @override
  String get notificationsMarkAllRead => 'Read all';

  @override
  String get notificationsEmptyTitle => 'All caught up';

  @override
  String get notificationsEmptyMessage =>
      'You have no new notifications at the moment.';

  @override
  String get notificationsConnectionError => 'Connection Error';

  @override
  String get notificationsErrorHint =>
      'Check if the index was created in Firebase.';

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileTagLabel => 'Your Tag (User ID)';

  @override
  String get profileTagCopied => 'Tag copied!';

  @override
  String get profileGeneratingId => 'Generating ID...';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profilePhoneHint => 'Add your phone';

  @override
  String get profileBirthDateLabel => 'Date of Birth';

  @override
  String get profileGenderLabel => 'Gender';

  @override
  String get profileGenderSelect => 'Select';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderOther => 'Other';

  @override
  String get profileGenderPreferNotToSay => 'Prefer not to say';

  @override
  String get profileSaveButton => 'Save changes';

  @override
  String get profileDeleteAccountTitle => 'Delete account';

  @override
  String get profileDeleteAccountSubtitle => 'Permanently remove your data';

  @override
  String get profileLogoutTitle => 'Log Out';

  @override
  String get profileLogoutSubtitle => 'End session on this device';

  @override
  String get profilePhotoGallery => 'Gallery';

  @override
  String get profilePhotoCamera => 'Camera';

  @override
  String get profilePhotoUpdated => 'Profile photo updated!';

  @override
  String get profileUpdated => 'Profile updated!';

  @override
  String get profileDeleteConfirmMessage =>
      'This action is irreversible. All your data will be lost. Do you want to continue?';

  @override
  String get subscriptionsTitle => 'Minhas Assinaturas';

  @override
  String get subscriptionsSubtitle => 'Acompanhe seus gastos recorrentes';

  @override
  String get subscriptionsTotalMonthly => 'Total mensal';

  @override
  String subscriptionsActiveCount(Object count) {
    return '$count ativas';
  }

  @override
  String get subscriptionsEmptyTitle => 'Nenhuma assinatura cadastrada';

  @override
  String get subscriptionsEmptyMessage =>
      'Adicione suas assinaturas\npara acompanhar os gastos';

  @override
  String get subscriptionsAddButton => 'Adicionar assinatura';

  @override
  String get subscriptionsDeleteTitle => 'Excluir assinatura';

  @override
  String subscriptionsDeleteMessage(Object name) {
    return 'Deseja excluir \"$name\"?';
  }

  @override
  String get newSubscriptionTitle => 'Nova Assinatura';

  @override
  String get subscriptionNameLabel => 'Nome da assinatura';

  @override
  String get subscriptionNameHint => 'Ex: Netflix, Spotify';

  @override
  String get subscriptionNameRequired => 'Digite um nome';

  @override
  String get subscriptionFrequencyLabel => 'Frequência';

  @override
  String get subscriptionBillingDayLabel => 'Dia de cobrança';

  @override
  String get subscriptionIconLabel => 'Ícone';

  @override
  String get subscriptionAddedSuccess => 'Assinatura adicionada!';

  @override
  String get dashboardTitle => 'Dashboards';

  @override
  String get dashboardMonthlyOverview => 'Visão Geral Mensal';

  @override
  String get dashboardExpenseByCategory => 'Despesas por Categoria';

  @override
  String get dashboardIncomeByCategory => 'Receitas por Categoria';

  @override
  String get dashboardNoData => 'Sem dados para exibir';

  @override
  String get dashboardTouchDetails => 'Segure para ver detalhes';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get aboutDescriptionTitle => 'Sua ferramenta completa para';

  @override
  String get aboutDescriptionSubtitle => 'gerenciamento financeiro pessoal';

  @override
  String get aboutDescriptionBody =>
      'Controle suas receitas, despesas, e alcance seus objetivos financeiros de forma simples e intuitiva.';

  @override
  String get aboutFeatureExpenses => 'Receitas & Despesas';

  @override
  String get aboutFeatureExpensesDesc =>
      'Registre e categorize suas transações';

  @override
  String get aboutFeatureGoals => 'Objetivos';

  @override
  String get aboutFeatureGoalsDesc => 'Defina metas de economia e investimento';

  @override
  String get aboutFeatureSubscriptions => 'Inscrições';

  @override
  String get aboutFeatureSubscriptionsDesc =>
      'Acompanhe suas assinaturas recorrentes';

  @override
  String get aboutCopyright => '© 2026 iQoin. Todos os direitos reservados.';

  @override
  String get categoriesTitle => 'Categorias';

  @override
  String get categoriesTabExpenses => 'Despesas';

  @override
  String get categoriesTabIncome => 'Receitas';

  @override
  String get categoriesNewCategory => 'Nova Categoria';

  @override
  String get categoriesEditCategory => 'Editar Categoria';

  @override
  String get categoriesHistoryTip =>
      'Toque em uma categoria para ver o histórico';

  @override
  String get categoriesLoadError => 'Erro ao carregar categorias';

  @override
  String get categoriesEmpty => 'Nenhuma categoria encontrada';

  @override
  String get categoriesDeleteTitle => 'Excluir categoria?';

  @override
  String get categoriesDeleteMessage =>
      'Isso não excluirá as transações existentes.';

  @override
  String categoriesDeleted(String name) {
    return 'Categoria \"$name\" excluída';
  }

  @override
  String get categoriesNameHint => 'Nome da categoria';

  @override
  String get categoriesSaveButton => 'Salvar Alterações';

  @override
  String get categoriesAddButton => 'Adicionar';

  @override
  String get helpTitle => 'Ajuda e FAQ';

  @override
  String get helpHeaderTitle => 'Como podemos ajudar?';

  @override
  String get helpHeaderSubtitle => 'Confira as perguntas frequentes abaixo';

  @override
  String get helpContactTitle => 'Ainda tem dúvidas?';

  @override
  String get helpContactSubtitle => 'Entre em contato com o suporte';

  @override
  String get helpWhatsappButton => 'Fale Conosco no WhatsApp';

  @override
  String get helpWhatsappError => 'Não foi possível abrir o WhatsApp';

  @override
  String get helpFaq1Question => 'Como adiciono uma nova transação?';

  @override
  String get helpFaq1Answer =>
      'Na tela inicial, toque na aba \"Despesas\" ou \"Receitas\" e use o botão \"+\" no canto inferior direito. Preencha os dados e salve.';

  @override
  String get helpFaq2Question => 'Posso editar uma transação?';

  @override
  String get helpFaq2Answer =>
      'Atualmente, para garantir a integridade dos dados, recomendamos excluir a transação incorreta (deslizando para a esquerda) e criar uma nova.';

  @override
  String get helpFaq3Question => 'Como funcionam os Objetivos?';

  @override
  String get helpFaq3Answer =>
      'Na aba \"Objetivos\", você pode criar metas financeiras (ex: Viagem, Carro). Defina um valor alvo e adicione economias progressivamente para acompanhar seu progresso visualmente.';

  @override
  String get helpFaq4Question => 'O que são as Inscrições?';

  @override
  String get helpFaq4Answer =>
      'A aba \"Inscrições\" serve para listar seus gastos recorrentes (Netflix, Spotify, Academia). Isso ajuda a visualizar quanto do seu orçamento mensal já está comprometido.';

  @override
  String get helpFaq5Question => 'Meus dados estão seguros?';

  @override
  String get helpFaq5Answer =>
      'Sim! Seus dados são armazenados na nuvem do Google (Firebase) com autenticação segura. Apenas você tem acesso às suas informações.';

  @override
  String get helpFaq6Question => 'Como altero minha senha?';

  @override
  String get helpFaq6Answer =>
      'Vá até o menu lateral, toque em \"Perfil\" e selecione a opção \"Alterar senha\". Um email de redefinição será enviado para você.';
}
