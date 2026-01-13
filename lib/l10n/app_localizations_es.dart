// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Configuración';

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
      'Aquí puedes personalizar la apariencia de la app y elegir tu idioma preferido.';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get loginSubtitle =>
      'Inicia sesión para continuar gestionando tus finanzas';

  @override
  String get emailLabel => 'Correo';

  @override
  String get emailHint => 'tu@email.com';

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
  String get emailRequired => 'Ingrese su correo';

  @override
  String get emailInvalid => 'Correo inválido';

  @override
  String get passwordRequired => 'Ingrese su contraseña';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get expenses => 'Gastos';

  @override
  String get income => 'Ingresos';

  @override
  String get currentEnvironment => 'Ambiente Actual';

  @override
  String get selectEnvironment => 'Seleccione un ambiente';

  @override
  String get balance => 'Saldo';

  @override
  String get viewModeTip =>
      'Modo visualización: no puedes añadir transacciones en meses pasados.';

  @override
  String get selectMonth => 'Seleccionar Mes';

  @override
  String get currentTag => 'Actual';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Comienza a organizar tus finanzas ahora';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Tu nombre completo';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Escribe nuevamente';

  @override
  String get registerButton => 'Crear cuenta';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get nameRequired => 'Ingrese su nombre';

  @override
  String get nameMinLength => 'Nombre demasiado corto';

  @override
  String get confirmPasswordRequired => 'Confirme su contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get myEnvironmentsTitle => 'Mis Ambientes';

  @override
  String get generatingId => 'Generando ID...';

  @override
  String get tagCopied => '¡Etiqueta copiada al portapapeles!';

  @override
  String get errorLoadingEnvironments => 'Error al cargar ambientes';

  @override
  String get yourEnvironmentsSection => 'Tus Ambientes';

  @override
  String get defaultTag => 'Predeterminado';

  @override
  String get sharedTag => 'Compartido';

  @override
  String get inviteTooltip => 'Invitar';

  @override
  String get leaveTooltip => 'Salir del Ambiente';

  @override
  String get howItWorksTitle => '¿Cómo funcionan los Ambientes?';

  @override
  String get howItWorksDescription =>
      'Los ambientes son espacios aislados para organizar tus finanzas por separado.';

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
  String inviteUserMessage(String envName) {
    return 'Invita a alguien a unirse al ambiente \"$envName\". Ingrese la etiqueta del usuario (ej: #12345).';
  }

  @override
  String get userTagLabel => 'Etiqueta del Usuario';

  @override
  String get cancel => 'Cancelar';

  @override
  String get send => 'Enviar';

  @override
  String get inviteSentSuccess => '¡Invitación enviada con éxito!';

  @override
  String get pendingInvitesTitle => 'Invitaciones Pendientes';

  @override
  String get noPendingInvites => 'Sin invitaciones pendientes.';

  @override
  String invitedBy(String userName) {
    return 'Invitado por: $userName';
  }

  @override
  String get decline => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get leaveEnvironmentTitle => 'Salir del Ambiente';

  @override
  String leaveEnvironmentMessage(String envName) {
    return '¿Estás seguro de que quieres salir del ambiente \"$envName\"? Perderás acceso a todos los datos compartidos.';
  }

  @override
  String get leaveSuccess => 'Saliste del ambiente con éxito.';

  @override
  String get leaveError => 'Error al salir del ambiente.';

  @override
  String get leaveButton => 'Salir';

  @override
  String get newEnvironmentTitle => 'Nuevo Ambiente';

  @override
  String get editEnvironmentTitle => 'Editar Ambiente';

  @override
  String get deleteEnvironmentTitle => 'Eliminar Ambiente';

  @override
  String get deleteEnvironmentMessage =>
      '¿Estás seguro? Esto no borrará las transacciones asociadas por ahora (serán inaccesibles).';

  @override
  String get environmentNameLabel => 'Nombre del Ambiente';

  @override
  String get environmentNameRequired => 'Ingrese un nombre';

  @override
  String get colorLabel => 'Color';

  @override
  String get iconLabel => 'Ícono';

  @override
  String get setAsDefault => 'Definir como predeterminado';

  @override
  String get createEnvironmentButton => 'CREAR AMBIENTE';

  @override
  String get saveChangesButton => 'GUARDAR CAMBIOS';

  @override
  String saveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get resetPasswordTitle => 'Restablecer Contraseña';

  @override
  String get resetPasswordSubtitle =>
      'Ingrese su correo para recibir un enlace de restablecimiento.';

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
  String get noCategoriesAvailable => 'Sin categorías disponibles';

  @override
  String get createCategoriesFirst =>
      'Cree categorías primero en \"Categorías\"';

  @override
  String get descriptionOptionalLabel => 'Descripción (opcional)';

  @override
  String get descriptionHint => 'Ej: Compras en el supermercado';

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
  String get goalsSubtitle => 'Define metas y sigue tu progreso';

  @override
  String goalsLoadError(String error) {
    return 'Error al cargar objetivos: $error';
  }

  @override
  String get noGoalsTitle => 'Sin objetivos definidos';

  @override
  String get noGoalsMessage => 'Crea metas para ahorrar\ny alcanzar tus sueños';

  @override
  String get createGoalButton => 'Crear objetivo';

  @override
  String get userUnidentifiedError => 'Error: Usuario no identificado';

  @override
  String get addValueTitle => 'Añadir valor';

  @override
  String get valueLabel => 'Valor (\$)';

  @override
  String get addButton => 'Añadir';

  @override
  String get deleteGoalTitle => 'Eliminar objetivo';

  @override
  String deleteGoalMessage(String goalName) {
    return '¿Deseas eliminar \"$goalName\"?';
  }

  @override
  String get newGoalTitle => 'Nuevo Objetivo';

  @override
  String get goalNameLabel => 'Nombre del Objetivo';

  @override
  String get goalNameHint => 'Ex: Viagem para praia';

  @override
  String get goalNameRequired => 'Digite um nome';

  @override
  String get targetAmountLabel => 'Valor alvo';

  @override
  String get targetAmountRequired => 'Ingrese un monto';

  @override
  String get deadlineDateLabel => 'Data limite';

  @override
  String daysRemaining(int days) {
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
  String daysRemainingSuffix(int days) {
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
  String get viewOnlyLabel => 'Solo lectura';

  @override
  String get yourExpensesTitle => 'Tus gastos';

  @override
  String get yourIncomeTitle => 'Tus ingresos';

  @override
  String get noExpenseFound => 'Sin gastos encontrados';

  @override
  String get noIncomeFound => 'Sin ingresos encontrados';

  @override
  String get noExpenseRegistered => 'Sin gastos registrados';

  @override
  String get noIncomeRegistered => 'Sin ingresos registrados';

  @override
  String get noExpenseThisMonth => 'Sin gastos este mes';

  @override
  String get noIncomeThisMonth => 'Sin ingresos este mes';

  @override
  String get filterExpensesTitle => 'Filtrar Gastos';

  @override
  String get filterIncomeTitle => 'Filtrar Ingresos';

  @override
  String get cleanFilters => 'Limpiar';

  @override
  String get periodLabel => 'Período';

  @override
  String get dateFrom => 'Desde';

  @override
  String get dateTo => 'Hasta';

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
  String get expenseCategoriesTitle => 'Categorías de Gastos';

  @override
  String get incomeCategoriesTitle => 'Categorías de Ingresos';

  @override
  String get newCategoryTitle => 'Nueva Categoría';

  @override
  String get categoryNameHint => 'Nombre de la Categoría';

  @override
  String get selectIconLabel => 'Seleccionar Ícono';

  @override
  String get addCategoryButton => 'Añadir Categoría';

  @override
  String get yourCategoriesTitle => 'Tus Categorías';

  @override
  String get noCategoriesCreated => 'Sin categorías creadas';

  @override
  String get addCategoriesAboveTip => 'Añade categorías arriba para comenzar';

  @override
  String get editCategoryTitle => 'Editar Categoría';

  @override
  String get deleteCategoryTitle => 'Eliminar Categoría';

  @override
  String deleteCategoryMessage(String name) {
    return '¿Deseas eliminar \"$name\"?';
  }

  @override
  String get enterCategoryNameError => 'Ingrese un nombre de categoría';

  @override
  String get categoryAddedSuccess => '¡Categoría agregada!';

  @override
  String get addCategoryError => 'Error al agregar categoría';

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
  String get drawerMyProfile => 'Mi Perfil';

  @override
  String get drawerHelp => 'Ayuda';

  @override
  String get drawerAbout => 'Acerca de';

  @override
  String get drawerSettings => 'Configuración';

  @override
  String get drawerLogout => 'Cerrar Sesión';

  @override
  String get drawerLogoutConfirmTitle => 'Confirmar Saída';

  @override
  String get drawerLogoutConfirmMessage =>
      'Tem certeza que deseja desconectar sua conta?';

  @override
  String get drawerVersion => 'Versión 1.0.0';

  @override
  String get notificationsTitle => 'Centro de Notificaciones';

  @override
  String notificationsUnread(int count) {
    return '$count no leídas';
  }

  @override
  String get notificationsAllRead => 'Todas leídas';

  @override
  String get notificationsMarkAllRead => 'Marcar todas';

  @override
  String get notificationsEmptyTitle => 'Todo al día';

  @override
  String get notificationsEmptyMessage =>
      'No tienes nuevas notificaciones en este momento.';

  @override
  String get notificationsConnectionError => 'Error de Conexión';

  @override
  String get notificationsErrorHint =>
      'Verifica si el índice de Firebase ha sido creado.';

  @override
  String get timeYesterday => 'Ayer';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileTagLabel => 'Mi Etiqueta';

  @override
  String get profileTagCopied => '¡Etiqueta copiada al portapapeles!';

  @override
  String get profileGeneratingId => 'Gerando ID...';

  @override
  String get profileNameLabel => 'Nombre Completo';

  @override
  String get profilePhoneLabel => 'Teléfono';

  @override
  String get profilePhoneHint => 'Adicione seu telefone';

  @override
  String get profileBirthDateLabel => 'Fecha de Nacimiento';

  @override
  String get profileGenderLabel => 'Género';

  @override
  String get profileGenderSelect => 'Seleccionar género';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Femenino';

  @override
  String get profileGenderOther => 'Otro';

  @override
  String get profileGenderPreferNotToSay => 'Prefiero no decirlo';

  @override
  String get profileSaveButton => 'Guardar Cambios';

  @override
  String get profileDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get profileDeleteAccountSubtitle =>
      'Eliminar permanentemente sus datos';

  @override
  String get profileLogoutTitle => 'Cerrar sesión';

  @override
  String get profileLogoutSubtitle => 'Finalizar sesión en este dispositivo';

  @override
  String get profilePhotoGallery => 'Galería';

  @override
  String get profilePhotoCamera => 'Cámara';

  @override
  String get profilePhotoUpdated => '¡Foto de perfil actualizada con éxito!';

  @override
  String get profileUpdated => '¡Perfil actualizado con éxito!';

  @override
  String get profileDeleteConfirmMessage =>
      'Esta acción es irreversible. Todos tus datos se perderán. ¿Deseas continuar?';

  @override
  String get subscriptionsTitle => 'Mis Suscripciones';

  @override
  String get subscriptionsSubtitle => 'Sigue tus gastos recurrentes';

  @override
  String get subscriptionsTotalMonthly => 'Total Mensual';

  @override
  String subscriptionsActiveCount(int count) {
    return '$count activas';
  }

  @override
  String get subscriptionsEmptyTitle => 'Sin suscripciones registradas';

  @override
  String get subscriptionsEmptyMessage =>
      'Añade tus suscripciones\npara seguir los gastos';

  @override
  String get subscriptionsAddButton => 'Añadir Suscripción';

  @override
  String get subscriptionsDeleteTitle => 'Eliminar Suscripción';

  @override
  String subscriptionsDeleteMessage(String name) {
    return '¿Deseas eliminar \"$name\"?';
  }

  @override
  String get newSubscriptionTitle => 'Nueva Suscripción';

  @override
  String get subscriptionNameLabel => 'Nombre de la Suscripción';

  @override
  String get subscriptionNameHint => 'Ej: Netflix, Spotify';

  @override
  String get subscriptionNameRequired => 'Ingrese un nombre';

  @override
  String get subscriptionFrequencyLabel => 'Frecuencia';

  @override
  String get subscriptionBillingDayLabel => 'Día de Cobro';

  @override
  String get subscriptionIconLabel => 'Ícono';

  @override
  String get subscriptionAddedSuccess => '¡Suscripción agregada!';

  @override
  String get dashboardTitle => 'Tableros';

  @override
  String get dashboardMonthlyOverview => 'Resumen Mensual';

  @override
  String get dashboardExpenseByCategory => 'Gastos por Categoría';

  @override
  String get dashboardIncomeByCategory => 'Ingresos por Categoría';

  @override
  String get dashboardNoData => 'Sin datos para mostrar';

  @override
  String get dashboardTouchDetails => 'Toque para ver detalles';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutDescriptionTitle => 'Tu herramienta completa para';

  @override
  String get aboutDescriptionSubtitle => 'gestión financiera personal';

  @override
  String get aboutDescriptionBody =>
      'Controla tus ingresos, gastos y alcanza tus objetivos financieros de manera simple e intuitiva.';

  @override
  String get aboutFeatureExpenses => 'Ingresos y Gastos';

  @override
  String get aboutFeatureExpensesDesc =>
      'Registra y categoriza tus transacciones';

  @override
  String get aboutFeatureGoals => 'Objetivos';

  @override
  String get aboutFeatureGoalsDesc => 'Define metas de ahorro e inversión';

  @override
  String get aboutFeatureSubscriptions => 'Inscripciones';

  @override
  String get aboutFeatureSubscriptionsDesc =>
      'Sigue tus suscripciones recurrentes';

  @override
  String get aboutCopyright => '© 2026 iQoin. Todos los derechos reservados.';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get categoriesTabExpenses => 'Gastos';

  @override
  String get categoriesTabIncome => 'Ingresos';

  @override
  String get categoriesNewCategory => 'Nueva Categoría';

  @override
  String get categoriesEditCategory => 'Editar Categoría';

  @override
  String get categoriesHistoryTip =>
      'Toque una categoría para ver el historial';

  @override
  String get categoriesLoadError => 'Error al cargar categorías';

  @override
  String get categoriesEmpty => 'No se encontraron categorías';

  @override
  String get categoriesDeleteTitle => '¿Eliminar categoría?';

  @override
  String get categoriesDeleteMessage =>
      'Esto no eliminará las transacciones existentes.';

  @override
  String categoriesDeleted(String name) {
    return 'Categoría \"$name\" eliminada';
  }

  @override
  String get categoriesNameHint => 'Nombre de la categoría';

  @override
  String get categoriesSaveButton => 'Guardar Cambios';

  @override
  String get categoriesAddButton => 'Añadir';

  @override
  String get helpTitle => 'Ayuda y FAQ';

  @override
  String get helpHeaderTitle => '¿Cómo podemos ayudar?';

  @override
  String get helpHeaderSubtitle =>
      'Consulta las preguntas frecuentes a continuación';

  @override
  String get helpContactTitle => '¿Aún tienes dudas?';

  @override
  String get helpContactSubtitle => 'Contactar soporte';

  @override
  String get helpWhatsappButton => 'Hable con nosotros en WhatsApp';

  @override
  String get helpWhatsappError => 'No se pudo abrir WhatsApp';

  @override
  String get helpFaq1Question => '¿Cómo añado una nueva transacción?';

  @override
  String get helpFaq1Answer =>
      'En la pantalla de inicio, toque la pestaña \"Gastos\" o \"Ingresos\" y use el botón \"+\" en la esquina inferior derecha. Complete los datos y guarde.';

  @override
  String get helpFaq2Question => '¿Puedo editar una transacción?';

  @override
  String get helpFaq2Answer =>
      'Actualmente, para garantizar la integridad de los datos, recomendamos eliminar la transacción incorrecta (deslizando hacia la izquierda) y crear una nueva.';

  @override
  String get helpFaq3Question => '¿Cómo funcionan los Objetivos?';

  @override
  String get helpFaq3Answer =>
      'En la pestaña \"Objetivos\", puede crear metas financieras (ej: Viaje, Coche). Defina un monto objetivo y agregue ahorros progresivamente para ver su progreso visualmente.';

  @override
  String get helpFaq4Question => '¿Qué son las Inscripciones?';

  @override
  String get helpFaq4Answer =>
      'La pestaña \"Inscripciones\" sirve para listar sus gastos recurrentes (Netflix, Spotify, Gimnasio). Esto ayuda a visualizar cuánto de su presupuesto mensual ya está comprometido.';

  @override
  String get helpFaq5Question => '¿Están seguros mis datos?';

  @override
  String get helpFaq5Answer =>
      '¡Sí! Sus datos se almacenan en la nube de Google (Firebase) con autenticación segura. Solo usted tiene acceso a su información.';

  @override
  String get helpFaq6Question => '¿Cómo cambio mi contraseña?';

  @override
  String get helpFaq6Answer =>
      'Vaya al menú lateral, toque en \"Perfil\" y seleccione la opción \"Cambiar contraseña\". Se le enviará un correo electrónico de restablecimiento.';

  @override
  String get tabDashboard => 'Tablero';

  @override
  String get tabGoals => 'Metas';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabCategories => 'Categ.';

  @override
  String get tabSubscriptions => 'Inscr.';

  @override
  String get settingsReplayTutorial => 'Repetir Tutorial';

  @override
  String get onboardingTitle1 => 'Rastrea tus gastos';

  @override
  String get onboardingDesc1 =>
      'Ten el control total de tus finanzas con gráficos detallados y categorías personalizadas.';

  @override
  String get onboardingTitle2 => 'Define metas inteligentes';

  @override
  String get onboardingDesc2 =>
      'Alcanza tus sueños creando metas y siguiendo tu progreso mes a mes.';

  @override
  String get onboardingTitle3 => 'Suscripciones y Alertas';

  @override
  String get onboardingDesc3 =>
      'Gestiona tus servicios recurrentes y recibe recordatorios antes del vencimiento.';

  @override
  String get onboardingGetStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Saltar';

  @override
  String get close => 'Cerrar';
}
