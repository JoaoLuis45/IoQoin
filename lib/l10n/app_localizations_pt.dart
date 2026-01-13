// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsInfoTitle => 'Sobre esta tela';

  @override
  String get settingsInfoDescription =>
      'Aqui você pode personalizar a aparência do app e escolher seu idioma preferido.';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get welcomeBack => 'Bem-vindo de volta!';

  @override
  String get loginSubtitle => 'Entre para continuar gerenciando suas finanças';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'seu@email.com';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get createAccountText => 'Não tem uma conta?';

  @override
  String get createAccountButton => 'Criar conta';

  @override
  String get emailRequired => 'Digite seu email';

  @override
  String get emailInvalid => 'Email inválido';

  @override
  String get passwordRequired => 'Digite sua senha';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get expenses => 'Despesas';

  @override
  String get income => 'Receitas';

  @override
  String get currentEnvironment => 'Ambiente Atual';

  @override
  String get selectEnvironment => 'Selecione um ambiente';

  @override
  String get balance => 'Saldo';

  @override
  String get viewModeTip =>
      'Modo visualização: não é possível adicionar transações em meses passados.';

  @override
  String get selectMonth => 'Selecionar Mês';

  @override
  String get currentTag => 'Atual';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get registerSubtitle => 'Comece a organizar suas finanças agora';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nameHint => 'Seu nome completo';

  @override
  String get confirmPasswordLabel => 'Confirmar senha';

  @override
  String get confirmPasswordHint => 'Digite novamente';

  @override
  String get registerButton => 'Criar conta';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get nameRequired => 'Digite seu nome';

  @override
  String get nameMinLength => 'Nome muito curto';

  @override
  String get confirmPasswordRequired => 'Confirme sua senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get myEnvironmentsTitle => 'Meus Ambientes';

  @override
  String get generatingId => 'Gerando ID...';

  @override
  String get tagCopied => 'Tag copiada para a área de transferência!';

  @override
  String get errorLoadingEnvironments => 'Erro ao carregar ambientes';

  @override
  String get yourEnvironmentsSection => 'Seus Ambientes';

  @override
  String get defaultTag => 'Padrão';

  @override
  String get sharedTag => 'Compartilhado';

  @override
  String get inviteTooltip => 'Convidar';

  @override
  String get leaveTooltip => 'Sair do Ambiente';

  @override
  String get howItWorksTitle => 'Como funcionam os Ambientes?';

  @override
  String get howItWorksDescription =>
      'Ambientes são espaços isolados para organizar suas finanças separadamente.';

  @override
  String get personalEnvironment =>
      'Pessoal: seus gastos diários e investimentos.';

  @override
  String get workEnvironment => 'Trabalho: receitas e despesas profissionais.';

  @override
  String get travelEnvironment => 'Viagens: orçamentos para suas aventuras.';

  @override
  String get inviteUserTitle => 'Convidar Usuário';

  @override
  String inviteUserMessage(String envName) {
    return 'Convide alguém para participar do ambiente \"$envName\". Digite a TAG do usuário (ex: #12345).';
  }

  @override
  String get userTagLabel => 'Tag do Usuário';

  @override
  String get cancel => 'Cancelar';

  @override
  String get send => 'Enviar';

  @override
  String get inviteSentSuccess => 'Convite enviado com sucesso!';

  @override
  String get pendingInvitesTitle => 'Convites Pendentes';

  @override
  String get noPendingInvites => 'Nenhum convite pendente.';

  @override
  String invitedBy(String userName) {
    return 'Convidado por: $userName';
  }

  @override
  String get decline => 'Recusar';

  @override
  String get accept => 'Aceitar';

  @override
  String get leaveEnvironmentTitle => 'Sair do Ambiente';

  @override
  String leaveEnvironmentMessage(String envName) {
    return 'Tem certeza que deseja sair do ambiente \"$envName\"? Você perderá o acesso a todos os dados compartilhados.';
  }

  @override
  String get leaveSuccess => 'Você saiu do ambiente com sucesso.';

  @override
  String get leaveError => 'Erro ao sair do ambiente.';

  @override
  String get leaveButton => 'Sair';

  @override
  String get newEnvironmentTitle => 'Novo Ambiente';

  @override
  String get editEnvironmentTitle => 'Editar Ambiente';

  @override
  String get deleteEnvironmentTitle => 'Excluir Ambiente';

  @override
  String get deleteEnvironmentMessage =>
      'Tem certeza? Isso não apagará as transações associadas por enquanto (serão inacessíveis).';

  @override
  String get environmentNameLabel => 'Nome do Ambiente';

  @override
  String get environmentNameRequired => 'Informe um nome';

  @override
  String get colorLabel => 'Cor';

  @override
  String get iconLabel => 'Ícone';

  @override
  String get setAsDefault => 'Definir como padrão';

  @override
  String get createEnvironmentButton => 'CRIAR AMBIENTE';

  @override
  String get saveChangesButton => 'SALVAR ALTERAÇÕES';

  @override
  String saveError(String error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String get resetPasswordTitle => 'Recuperar Senha';

  @override
  String get resetPasswordSubtitle =>
      'Digite seu email para receber um link de redefinição de senha.';

  @override
  String get resetPasswordError =>
      'Erro ao enviar email. Verifique o endereço.';

  @override
  String get sendLinkButton => 'Enviar Link';

  @override
  String get emailSentTitle => 'Email Enviado!';

  @override
  String get emailSentMessage =>
      'Verifique sua caixa de entrada (e spam) para redefinir sua senha.';

  @override
  String get gotIt => 'Entendi';

  @override
  String errorMessage(Object error) {
    return 'Erro: $error';
  }

  @override
  String get addExpenseTitle => 'Adicionar Despesa';

  @override
  String get addIncomeTitle => 'Adicionar Receita';

  @override
  String get fixedTransactionsTitle =>
      'Transações Fixas (Preenchimento Rápido)';

  @override
  String get amountLabel => 'Valor';

  @override
  String get quickValuesTitle => 'Valores rápidos';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get selectCategoryError => 'Selecione uma categoria';

  @override
  String get noCategoriesAvailable => 'Nenhuma categoria disponível';

  @override
  String get createCategoriesFirst =>
      'Crie categorias primeiro em \"Categorias\"';

  @override
  String get descriptionOptionalLabel => 'Descrição (Opcional)';

  @override
  String get descriptionHint => 'Ex: Compra no supermercado';

  @override
  String get dateLabel => 'Data';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get invalidAmountError => 'Digite um valor válido';

  @override
  String get expenseAddedSuccess => 'Despesa adicionada com sucesso!';

  @override
  String get incomeAddedSuccess => 'Receita adicionada com sucesso!';

  @override
  String get addTransactionError => 'Erro ao adicionar. Tente novamente.';

  @override
  String get myGoalsTitle => 'Meus Objetivos';

  @override
  String get goalsSubtitle => 'Defina metas e acompanhe seu progresso';

  @override
  String goalsLoadError(String error) {
    return 'Erro ao carregar objetivos: $error';
  }

  @override
  String get noGoalsTitle => 'Nenhum objetivo definido';

  @override
  String get noGoalsMessage =>
      'Crie metas para economizar\ne alcançar seus sonhos';

  @override
  String get createGoalButton => 'Criar objetivo';

  @override
  String get userUnidentifiedError => 'Erro: Usuário não identificado';

  @override
  String get addValueTitle => 'Adicionar valor';

  @override
  String get valueLabel => 'Valor (R\$)';

  @override
  String get addButton => 'Adicionar';

  @override
  String get deleteGoalTitle => 'Excluir objetivo';

  @override
  String deleteGoalMessage(String goalName) {
    return 'Deseja excluir \"$goalName\"?';
  }

  @override
  String get newGoalTitle => 'Novo Objetivo';

  @override
  String get goalNameLabel => 'Nome do objetivo';

  @override
  String get goalNameHint => 'Ex: Viagem para praia';

  @override
  String get goalNameRequired => 'Digite um nome';

  @override
  String get targetAmountLabel => 'Valor alvo';

  @override
  String get targetAmountRequired => 'Digite um valor';

  @override
  String get deadlineDateLabel => 'Data limite';

  @override
  String daysRemaining(int days) {
    return '$days dias';
  }

  @override
  String createGoalError(Object error) {
    return 'Erro ao criar objetivo: $error';
  }

  @override
  String get goalCreatedSuccess => 'Objetivo criado com sucesso!';

  @override
  String get goalCompletedStatus => 'Concluído!';

  @override
  String get goalOverdueStatus => 'Atrasado';

  @override
  String daysRemainingSuffix(int days) {
    return '$days dias restantes';
  }

  @override
  String get goalProgressOf => 'de';

  @override
  String get deleteTransactionTitle => 'Excluir transação';

  @override
  String get deleteTransactionMessage =>
      'Tem certeza que deseja excluir esta transação?';

  @override
  String get deleteButton => 'Excluir';

  @override
  String get filterLabel => 'Filtrar';

  @override
  String get fixedLabel => 'Fixas';

  @override
  String get adjustFiltersTip => 'Tente ajustar os filtros';

  @override
  String get tapToAddTip => 'Toque no + para adicionar';

  @override
  String get viewOnlyLabel => 'Apenas visualização';

  @override
  String get yourExpensesTitle => 'Suas despesas';

  @override
  String get yourIncomeTitle => 'Suas receitas';

  @override
  String get noExpenseFound => 'Nenhuma despesa encontrada';

  @override
  String get noIncomeFound => 'Nenhuma receita encontrada';

  @override
  String get noExpenseRegistered => 'Nenhuma despesa registrada';

  @override
  String get noIncomeRegistered => 'Nenhuma receita registrada';

  @override
  String get noExpenseThisMonth => 'Nenhuma despesa neste mês';

  @override
  String get noIncomeThisMonth => 'Nenhuma receita neste mês';

  @override
  String get filterExpensesTitle => 'Filtrar Despesas';

  @override
  String get filterIncomeTitle => 'Filtrar Receitas';

  @override
  String get cleanFilters => 'Limpar';

  @override
  String get periodLabel => 'Período';

  @override
  String get dateFrom => 'De';

  @override
  String get dateTo => 'Até';

  @override
  String get minLabel => 'Mínimo';

  @override
  String get maxLabel => 'Máximo';

  @override
  String get categoriesLabel => 'Categorias';

  @override
  String get noCategoriesFound => 'Nenhuma categoria encontrada.';

  @override
  String get applyFiltersButton => 'Aplicar Filtros';

  @override
  String get expenseCategoriesTitle => 'Categorias de Despesas';

  @override
  String get incomeCategoriesTitle => 'Categorias de Receitas';

  @override
  String get newCategoryTitle => 'Nova categoria';

  @override
  String get categoryNameHint => 'Nome da categoria';

  @override
  String get selectIconLabel => 'Selecione um ícone';

  @override
  String get addCategoryButton => 'Adicionar categoria';

  @override
  String get yourCategoriesTitle => 'Suas categorias';

  @override
  String get noCategoriesCreated => 'Nenhuma categoria criada';

  @override
  String get addCategoriesAboveTip => 'Adicione categorias acima';

  @override
  String get editCategoryTitle => 'Editar categoria';

  @override
  String get deleteCategoryTitle => 'Excluir categoria';

  @override
  String deleteCategoryMessage(String name) {
    return 'Deseja excluir \"$name\"?';
  }

  @override
  String get enterCategoryNameError => 'Digite o nome da categoria';

  @override
  String get categoryAddedSuccess => 'Categoria adicionada!';

  @override
  String get addCategoryError => 'Erro ao adicionar categoria';

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
  String get drawerMyProfile => 'Meu Perfil';

  @override
  String get drawerHelp => 'Ajuda';

  @override
  String get drawerAbout => 'Sobre o iQoin';

  @override
  String get drawerSettings => 'Configurações';

  @override
  String get drawerLogout => 'Sair';

  @override
  String get drawerLogoutConfirmTitle => 'Confirmar Saída';

  @override
  String get drawerLogoutConfirmMessage =>
      'Tem certeza que deseja desconectar sua conta?';

  @override
  String get drawerVersion => 'Versão';

  @override
  String get notificationsTitle => 'Central de Avisos';

  @override
  String notificationsUnread(int count) {
    return '$count não lidas';
  }

  @override
  String get notificationsAllRead => 'Todas lidas';

  @override
  String get notificationsMarkAllRead => 'Ler todas';

  @override
  String get notificationsEmptyTitle => 'Tudo tranquilo';

  @override
  String get notificationsEmptyMessage =>
      'Você não tem novas notificações no momento.';

  @override
  String get notificationsConnectionError => 'Erro de Conexão';

  @override
  String get notificationsErrorHint =>
      'Verifique se o índice foi criado no Firebase.';

  @override
  String get timeYesterday => 'Ontem';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileTagLabel => 'Sua Tag (ID de Usuário)';

  @override
  String get profileTagCopied => 'Tag copiada!';

  @override
  String get profileGeneratingId => 'Gerando ID...';

  @override
  String get profileNameLabel => 'Nome';

  @override
  String get profilePhoneLabel => 'Telefone';

  @override
  String get profilePhoneHint => 'Adicione seu telefone';

  @override
  String get profileBirthDateLabel => 'Data de Nascimento';

  @override
  String get profileGenderLabel => 'Gênero';

  @override
  String get profileGenderSelect => 'Selecione';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Feminino';

  @override
  String get profileGenderOther => 'Outro';

  @override
  String get profileGenderPreferNotToSay => 'Prefiro não informar';

  @override
  String get profileSaveButton => 'Salvar alterações';

  @override
  String get profileDeleteAccountTitle => 'Excluir conta';

  @override
  String get profileDeleteAccountSubtitle =>
      'Remover permanentemente seus dados';

  @override
  String get profileLogoutTitle => 'Sair';

  @override
  String get profileLogoutSubtitle => 'Encerrar sessão neste dispositivo';

  @override
  String get profilePhotoGallery => 'Galeria';

  @override
  String get profilePhotoCamera => 'Câmera';

  @override
  String get profilePhotoUpdated => 'Foto de perfil atualizada!';

  @override
  String get profileUpdated => 'Perfil atualizado!';

  @override
  String get profileDeleteConfirmMessage =>
      'Esta ação é irreversível. Todos os seus dados serão perdidos. Deseja continuar?';

  @override
  String get subscriptionsTitle => 'Minhas Assinaturas';

  @override
  String get subscriptionsSubtitle => 'Acompanhe seus gastos recorrentes';

  @override
  String get subscriptionsTotalMonthly => 'Total mensal';

  @override
  String subscriptionsActiveCount(int count) {
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
  String subscriptionsDeleteMessage(String name) {
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

  @override
  String get tabDashboard => 'Dash';

  @override
  String get tabGoals => 'Metas';

  @override
  String get tabHome => 'Início';

  @override
  String get tabCategories => 'Categ.';

  @override
  String get tabSubscriptions => 'Inscr.';

  @override
  String get settingsReplayTutorial => 'Rever Tutorial';

  @override
  String get onboardingTitle1 => 'Acompanhe seus gastos';

  @override
  String get onboardingDesc1 =>
      'Tenha controle total de suas finanças com gráficos detalhados e categorias personalizadas.';

  @override
  String get onboardingTitle2 => 'Defina metas inteligentes';

  @override
  String get onboardingDesc2 =>
      'Conquiste seus sonhos criando metas e acompanhando seu progresso mês a mês.';

  @override
  String get onboardingTitle3 => 'Assinaturas e Alertas';

  @override
  String get onboardingDesc3 =>
      'Gerencie seus serviços recorrentes e receba lembretes antes do vencimento.';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get next => 'Próximo';

  @override
  String get skip => 'Pular';

  @override
  String get close => 'Fechar';
}
