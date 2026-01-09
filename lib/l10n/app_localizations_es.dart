// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Configuraciones';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsInfoTitle => 'Sobre esta pantalla';

  @override
  String get settingsInfoDescription =>
      'Aquí puedes personalizar la apariencia de la aplicación y elegir tu idioma preferido.';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get loginSubtitle =>
      'Inicia sesión para continuar administrando tus finanzas';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'tu@correo.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get createAccountText => '¿No tienes una cuenta?';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get emailRequired => 'Ingresa tu correo';

  @override
  String get emailInvalid => 'Correo inválido';

  @override
  String get passwordRequired => 'Ingresa tu contraseña';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get expenses => 'Gastos';

  @override
  String get income => 'Ingresos';

  @override
  String get currentEnvironment => 'Entorno Actual';

  @override
  String get selectEnvironment => 'Selecciona un entorno';

  @override
  String get balance => 'Saldo';

  @override
  String get viewModeTip =>
      'Modo visualización: no puedes agregar transacciones en meses pasados.';

  @override
  String get selectMonth => 'Seleccionar Mes';

  @override
  String get currentTag => 'Actual';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Empieza a organizar tus finanzas ahora';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Tu nombre completo';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Escribe de nuevo';

  @override
  String get registerButton => 'Crear cuenta';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get nameRequired => 'Ingresa tu nombre';

  @override
  String get nameMinLength => 'Nombre muy corto';

  @override
  String get confirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get myEnvironmentsTitle => 'Mis Entornos';

  @override
  String get generatingId => 'Generando ID...';

  @override
  String get tagCopied => '¡Etiqueta copiada al portapapeles!';

  @override
  String get errorLoadingEnvironments => 'Error al cargar entornos';

  @override
  String get yourEnvironmentsSection => 'Tus Entornos';

  @override
  String get defaultTag => 'Predeterminado';

  @override
  String get sharedTag => 'Compartido';

  @override
  String get inviteTooltip => 'Invitar';

  @override
  String get leaveTooltip => 'Salir del Entorno';

  @override
  String get howItWorksTitle => '¿Cómo funcionan los Entornos?';

  @override
  String get howItWorksDescription =>
      'Los entornos son espacios aislados para organizar tus finanzas por separado.';

  @override
  String get personalEnvironment =>
      'Personal: tus gastos diarios e inversiones.';

  @override
  String get workEnvironment => 'Trabajo: ingresos y gastos profesionales.';

  @override
  String get travelEnvironment => 'Viajes: presupuestos para tus aventuras.';

  @override
  String get inviteUserTitle => 'Invitar Usuario';

  @override
  String inviteUserMessage(Object envName) {
    return 'Invita a alguien a unirse al entorno \"$envName\". Ingresa la etiqueta del usuario (ej. #12345).';
  }

  @override
  String get userTagLabel => 'Etiqueta de Usuario';

  @override
  String get cancel => 'Cancelar';

  @override
  String get send => 'Enviar';

  @override
  String get inviteSentSuccess => '¡Invitación enviada con éxito!';

  @override
  String get pendingInvitesTitle => 'Invitaciones Pendientes';

  @override
  String get noPendingInvites => 'No hay invitaciones pendientes.';

  @override
  String invitedBy(Object userName) {
    return 'Invitado por: $userName';
  }

  @override
  String get decline => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get leaveEnvironmentTitle => 'Salir del Entorno';

  @override
  String leaveEnvironmentMessage(Object envName) {
    return '¿Estás seguro de que quieres salir del entorno \"$envName\"? Perderás acceso a todos los datos compartidos.';
  }

  @override
  String get leaveSuccess => 'Has salido del entorno con éxito.';

  @override
  String get leaveError => 'Error al salir del entorno.';

  @override
  String get leaveButton => 'Salir';

  @override
  String get newEnvironmentTitle => 'Nuevo Entorno';

  @override
  String get editEnvironmentTitle => 'Editar Entorno';

  @override
  String get deleteEnvironmentTitle => 'Eliminar Entorno';

  @override
  String get deleteEnvironmentMessage =>
      '¿Estás seguro? Esto no eliminará las transacciones asociadas por ahora (serán inaccesibles).';

  @override
  String get environmentNameLabel => 'Nombre del Entorno';

  @override
  String get environmentNameRequired => 'Ingrese un nombre';

  @override
  String get colorLabel => 'Color';

  @override
  String get iconLabel => 'Icono';

  @override
  String get setAsDefault => 'Establecer como Predeterminado';

  @override
  String get createEnvironmentButton => 'CREAR ENTORNO';

  @override
  String get saveChangesButton => 'GUARDAR CAMBIOS';

  @override
  String saveError(Object error) {
    return 'Error al guardar. Verifique su conexión o permisos.';
  }

  @override
  String get resetPasswordTitle => 'Restablecer Contraseña';

  @override
  String get resetPasswordSubtitle =>
      'Ingrese su correo electrónico para recibir un enlace de restablecimiento de contraseña.';

  @override
  String get resetPasswordError =>
      'Error al enviar correo. Verifique la dirección.';

  @override
  String get sendLinkButton => 'Enviar Enlace';

  @override
  String get emailSentTitle => '¡Correo Enviado!';

  @override
  String get emailSentMessage =>
      'Verifique su bandeja de entrada (y spam) para restablecer su contraseña.';

  @override
  String get gotIt => 'Entendido';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get addExpenseTitle => 'Añadir Gasto';

  @override
  String get addIncomeTitle => 'Añadir Ingreso';

  @override
  String get fixedTransactionsTitle => 'Transacciones Fijas (Llenado Rápido)';

  @override
  String get amountLabel => 'Monto';

  @override
  String get quickValuesTitle => 'Valores rápidos';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get selectCategoryError => 'Seleccione una categoría';

  @override
  String get noCategoriesAvailable => 'No hay categorías disponibles';

  @override
  String get createCategoriesFirst =>
      'Cree categorías primero en \"Categorías\"';

  @override
  String get descriptionOptionalLabel => 'Descripción (Opcional)';

  @override
  String get descriptionHint => 'Ej: Compras del supermercado';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get invalidAmountError => 'Ingrese un monto válido';

  @override
  String get expenseAddedSuccess => '¡Gasto añadido con éxito!';

  @override
  String get incomeAddedSuccess => '¡Ingreso añadido con éxito!';

  @override
  String get addTransactionError => 'Error al añadir. Intente nuevamente.';

  @override
  String get myGoalsTitle => 'Mis Objetivos';

  @override
  String get goalsSubtitle => 'Establezca metas y siga su progreso';

  @override
  String goalsLoadError(Object error) {
    return 'Error al cargar objetivos: $error';
  }

  @override
  String get noGoalsTitle => 'Ningún objetivo definido';

  @override
  String get noGoalsMessage => 'Cree metas para ahorrar\ny alcanzar sus sueños';

  @override
  String get createGoalButton => 'Crear objetivo';

  @override
  String get userUnidentifiedError => 'Error: Usuario no identificado';

  @override
  String get addValueTitle => 'Añadir valor';

  @override
  String get valueLabel => 'Valor';

  @override
  String get addButton => 'Añadir';

  @override
  String get deleteGoalTitle => 'Eliminar objetivo';

  @override
  String deleteGoalMessage(Object goalName) {
    return '¿Desea eliminar \"$goalName\"?';
  }

  @override
  String get newGoalTitle => 'Nuevo Objetivo';

  @override
  String get goalNameLabel => 'Nombre del objetivo';

  @override
  String get goalNameHint => 'Ej: Viaje a la playa';

  @override
  String get goalNameRequired => 'Ingrese un nombre';

  @override
  String get targetAmountLabel => 'Monto objetivo';

  @override
  String get targetAmountRequired => 'Ingrese un monto';

  @override
  String get deadlineDateLabel => 'Fecha límite';

  @override
  String daysRemaining(Object days) {
    return '$days días';
  }

  @override
  String createGoalError(Object error) {
    return 'Error al crear objetivo: $error';
  }

  @override
  String get goalCreatedSuccess => '¡Objetivo creado con éxito!';

  @override
  String get goalCompletedStatus => '¡Completado!';

  @override
  String get goalOverdueStatus => 'Atrasado';

  @override
  String daysRemainingSuffix(Object days) {
    return '$days días restantes';
  }

  @override
  String get goalProgressOf => 'de';

  @override
  String get deleteTransactionTitle => 'Eliminar transacción';

  @override
  String get deleteTransactionMessage =>
      '¿Estás seguro de que quieres eliminar esta transacción?';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get filterLabel => 'Filtrar';

  @override
  String get fixedLabel => 'Fijas';

  @override
  String get adjustFiltersTip => 'Intenta ajustar los filtros';

  @override
  String get tapToAddTip => 'Toca + para añadir';

  @override
  String get viewOnlyLabel => 'Solo visualización';

  @override
  String get yourExpensesTitle => 'Tus gastos';

  @override
  String get yourIncomeTitle => 'Tus ingresos';

  @override
  String get noExpenseFound => 'Ningún gasto encontrado';

  @override
  String get noIncomeFound => 'Ningún ingreso encontrado';

  @override
  String get noExpenseRegistered => 'Ningún gasto registrado';

  @override
  String get noIncomeRegistered => 'Ningún ingreso registrado';

  @override
  String get noExpenseThisMonth => 'Ningún gasto en este mes';

  @override
  String get noIncomeThisMonth => 'Ningún ingreso en este mes';

  @override
  String get filterExpensesTitle => 'Filtrar Gastos';

  @override
  String get filterIncomeTitle => 'Filtrar Ingresos';

  @override
  String get cleanFilters => 'Limpiar';

  @override
  String get periodLabel => 'Período';

  @override
  String get dateFrom => 'De';

  @override
  String get dateTo => 'Hasta';

  @override
  String get minLabel => 'Mín';

  @override
  String get maxLabel => 'Máx';

  @override
  String get categoriesLabel => 'Categorías';

  @override
  String get noCategoriesFound => 'No se encontraron categorías.';

  @override
  String get applyFiltersButton => 'Aplicar Filtros';

  @override
  String get expenseCategoriesTitle => 'Categorías de Gastos';

  @override
  String get incomeCategoriesTitle => 'Categorías de Ingresos';

  @override
  String get newCategoryTitle => 'Nueva Categoría';

  @override
  String get categoryNameHint => 'Nombre de la categoría';

  @override
  String get selectIconLabel => 'Selecciona un icono';

  @override
  String get addCategoryButton => 'Añadir Categoría';

  @override
  String get yourCategoriesTitle => 'Tus Categorías';

  @override
  String get noCategoriesCreated => 'No hay categorías creadas';

  @override
  String get addCategoriesAboveTip => 'Añade categorías arriba';

  @override
  String get editCategoryTitle => 'Editar Categoría';

  @override
  String get deleteCategoryTitle => 'Eliminar Categoría';

  @override
  String deleteCategoryMessage(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get enterCategoryNameError => 'Ingrese el nombre de la categoría';

  @override
  String get categoryAddedSuccess => '¡Categoría añadida!';

  @override
  String get addCategoryError => 'Error al añadir categoría';

  @override
  String get enterValidValue => 'Por favor, ingrese un valor válido';

  @override
  String get templateSavedSuccess => '¡Plantilla guardada con éxito!';

  @override
  String get saveErrorMessage =>
      'Erro ao salvar. Verifique sua conexão ou permissões.';

  @override
  String get fixedExpensesTitle => 'Gastos Fijos';

  @override
  String get fixedIncomeTitle => 'Ingresos Fijos';

  @override
  String get manageTemplatesSubtitle => 'Gestione sus modelos de transacciones';

  @override
  String get createNewFixedButton => 'Crear Nueva Fija';

  @override
  String get loadError => 'Error al cargar datos';

  @override
  String get permissionOrIndexError =>
      'Esto puede ser falta de permiso o índice en Firebase.';

  @override
  String get noTemplatesFound => 'Sin modelos guardados';

  @override
  String get createTemplatesTip =>
      'Cree plantillas para agilizar el registro de facturas recurrentes como alquiler, salario, etc.';

  @override
  String get deleteTemplateTitle => '¿Eliminar?';

  @override
  String get deleteTemplateMessage => '¿Desea eliminar este modelo?';

  @override
  String get templateRemoved => 'Modelo eliminado';

  @override
  String get defaultAmountLabel => 'Valor Predeterminado';

  @override
  String get saveTemplateButton => 'Guardar Plantilla';

  @override
  String get drawerMyProfile => 'Mi perfil';

  @override
  String get drawerHelp => 'Ayuda';

  @override
  String get drawerAbout => 'Sobre iQoin';

  @override
  String get drawerSettings => 'Configuración';

  @override
  String get drawerLogout => 'Cerrar sesión';

  @override
  String get drawerLogoutConfirmTitle => 'Confirmar salida';

  @override
  String get drawerLogoutConfirmMessage =>
      '¿Estás seguro de que deseas desconectar tu cuenta?';

  @override
  String get drawerVersion => 'Versión';

  @override
  String get notificationsTitle => 'Centro de Avisos';

  @override
  String notificationsUnread(Object count) {
    return '$count no leídas';
  }

  @override
  String get notificationsAllRead => 'Todo leído';

  @override
  String get notificationsMarkAllRead => 'Leer todas';

  @override
  String get notificationsEmptyTitle => 'Todo tranquilo';

  @override
  String get notificationsEmptyMessage =>
      'No tienes nuevas notificaciones en este momento.';

  @override
  String get notificationsConnectionError => 'Error de conexión';

  @override
  String get notificationsErrorHint =>
      'Verifique si el índice fue creado en Firebase.';

  @override
  String get timeYesterday => 'Ayer';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get profileTagLabel => 'Tu Tag (ID de usuario)';

  @override
  String get profileTagCopied => '¡Tag copiado!';

  @override
  String get profileGeneratingId => 'Generando ID...';

  @override
  String get profileNameLabel => 'Nombre';

  @override
  String get profilePhoneLabel => 'Teléfono';

  @override
  String get profilePhoneHint => 'Añade tu teléfono';

  @override
  String get profileBirthDateLabel => 'Fecha de nacimiento';

  @override
  String get profileGenderLabel => 'Género';

  @override
  String get profileGenderSelect => 'Seleccionar';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Femenino';

  @override
  String get profileGenderOther => 'Otro';

  @override
  String get profileGenderPreferNotToSay => 'Prefiero no decirlo';

  @override
  String get profileSaveButton => 'Guardar cambios';

  @override
  String get profileDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get profileDeleteAccountSubtitle =>
      'Eliminar permanentemente tus datos';

  @override
  String get profileLogoutTitle => 'Cerrar sesión';

  @override
  String get profileLogoutSubtitle => 'Cerrar sesión en este dispositivo';

  @override
  String get profilePhotoGallery => 'Galería';

  @override
  String get profilePhotoCamera => 'Cámara';

  @override
  String get profilePhotoUpdated => '¡Foto de perfil actualizada!';

  @override
  String get profileUpdated => '¡Perfil actualizado!';

  @override
  String get profileDeleteConfirmMessage =>
      'Esta acción es irreversible. Todos tus datos se perderán. ¿Deseas continuar?';

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
