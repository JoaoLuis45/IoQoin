import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsInfoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sobre esta tela'**
  String get settingsInfoTitle;

  /// No description provided for @settingsInfoDescription.
  ///
  /// In pt, this message translates to:
  /// **'Aqui você pode personalizar a aparência do app e escolher seu idioma preferido.'**
  String get settingsInfoDescription;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo de volta!'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Entre para continuar gerenciando suas finanças'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In pt, this message translates to:
  /// **'seu@email.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In pt, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @createAccountText.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta?'**
  String get createAccountText;

  /// No description provided for @createAccountButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get createAccountButton;

  /// No description provided for @emailRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Email inválido'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua senha'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres'**
  String get passwordMinLength;

  /// No description provided for @expenses.
  ///
  /// In pt, this message translates to:
  /// **'Despesas'**
  String get expenses;

  /// No description provided for @income.
  ///
  /// In pt, this message translates to:
  /// **'Receitas'**
  String get income;

  /// No description provided for @currentEnvironment.
  ///
  /// In pt, this message translates to:
  /// **'Ambiente Atual'**
  String get currentEnvironment;

  /// No description provided for @selectEnvironment.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um ambiente'**
  String get selectEnvironment;

  /// No description provided for @balance.
  ///
  /// In pt, this message translates to:
  /// **'Saldo'**
  String get balance;

  /// No description provided for @viewModeTip.
  ///
  /// In pt, this message translates to:
  /// **'Modo visualização: não é possível adicionar transações em meses passados.'**
  String get viewModeTip;

  /// No description provided for @selectMonth.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Mês'**
  String get selectMonth;

  /// No description provided for @currentTag.
  ///
  /// In pt, this message translates to:
  /// **'Atual'**
  String get currentTag;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Comece a organizar suas finanças agora'**
  String get registerSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In pt, this message translates to:
  /// **'Seu nome completo'**
  String get nameHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite novamente'**
  String get confirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já tem uma conta?'**
  String get alreadyHaveAccount;

  /// No description provided for @nameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu nome'**
  String get nameRequired;

  /// No description provided for @nameMinLength.
  ///
  /// In pt, this message translates to:
  /// **'Nome muito curto'**
  String get nameMinLength;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Confirme sua senha'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não coincidem'**
  String get passwordsDoNotMatch;

  /// No description provided for @myEnvironmentsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meus Ambientes'**
  String get myEnvironmentsTitle;

  /// No description provided for @generatingId.
  ///
  /// In pt, this message translates to:
  /// **'Gerando ID...'**
  String get generatingId;

  /// No description provided for @tagCopied.
  ///
  /// In pt, this message translates to:
  /// **'Tag copiada para a área de transferência!'**
  String get tagCopied;

  /// No description provided for @errorLoadingEnvironments.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar ambientes'**
  String get errorLoadingEnvironments;

  /// No description provided for @yourEnvironmentsSection.
  ///
  /// In pt, this message translates to:
  /// **'Seus Ambientes'**
  String get yourEnvironmentsSection;

  /// No description provided for @defaultTag.
  ///
  /// In pt, this message translates to:
  /// **'Padrão'**
  String get defaultTag;

  /// No description provided for @sharedTag.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhado'**
  String get sharedTag;

  /// No description provided for @inviteTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Convidar'**
  String get inviteTooltip;

  /// No description provided for @leaveTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Sair do Ambiente'**
  String get leaveTooltip;

  /// No description provided for @howItWorksTitle.
  ///
  /// In pt, this message translates to:
  /// **'Como funcionam os Ambientes?'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksDescription.
  ///
  /// In pt, this message translates to:
  /// **'Ambientes são espaços isolados para organizar suas finanças separadamente.'**
  String get howItWorksDescription;

  /// No description provided for @personalEnvironment.
  ///
  /// In pt, this message translates to:
  /// **'Pessoal: seus gastos diários e investimentos.'**
  String get personalEnvironment;

  /// No description provided for @workEnvironment.
  ///
  /// In pt, this message translates to:
  /// **'Trabalho: receitas e despesas profissionais.'**
  String get workEnvironment;

  /// No description provided for @travelEnvironment.
  ///
  /// In pt, this message translates to:
  /// **'Viagens: orçamentos para suas aventuras.'**
  String get travelEnvironment;

  /// No description provided for @inviteUserTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convidar Usuário'**
  String get inviteUserTitle;

  /// No description provided for @inviteUserMessage.
  ///
  /// In pt, this message translates to:
  /// **'Convide alguém para participar do ambiente \"{envName}\". Digite a TAG do usuário (ex: #12345).'**
  String inviteUserMessage(String envName);

  /// No description provided for @userTagLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tag do Usuário'**
  String get userTagLabel;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In pt, this message translates to:
  /// **'Enviar'**
  String get send;

  /// No description provided for @inviteSentSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Convite enviado com sucesso!'**
  String get inviteSentSuccess;

  /// No description provided for @pendingInvitesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convites Pendentes'**
  String get pendingInvitesTitle;

  /// No description provided for @noPendingInvites.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum convite pendente.'**
  String get noPendingInvites;

  /// No description provided for @invitedBy.
  ///
  /// In pt, this message translates to:
  /// **'Convidado por: {userName}'**
  String invitedBy(String userName);

  /// No description provided for @decline.
  ///
  /// In pt, this message translates to:
  /// **'Recusar'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In pt, this message translates to:
  /// **'Aceitar'**
  String get accept;

  /// No description provided for @leaveEnvironmentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sair do Ambiente'**
  String get leaveEnvironmentTitle;

  /// No description provided for @leaveEnvironmentMessage.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja sair do ambiente \"{envName}\"? Você perderá o acesso a todos os dados compartilhados.'**
  String leaveEnvironmentMessage(String envName);

  /// No description provided for @leaveSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Você saiu do ambiente com sucesso.'**
  String get leaveSuccess;

  /// No description provided for @leaveError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao sair do ambiente.'**
  String get leaveError;

  /// No description provided for @leaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get leaveButton;

  /// No description provided for @newEnvironmentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Novo Ambiente'**
  String get newEnvironmentTitle;

  /// No description provided for @editEnvironmentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar Ambiente'**
  String get editEnvironmentTitle;

  /// No description provided for @deleteEnvironmentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Ambiente'**
  String get deleteEnvironmentTitle;

  /// No description provided for @deleteEnvironmentMessage.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza? Isso não apagará as transações associadas por enquanto (serão inacessíveis).'**
  String get deleteEnvironmentMessage;

  /// No description provided for @environmentNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome do Ambiente'**
  String get environmentNameLabel;

  /// No description provided for @environmentNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe um nome'**
  String get environmentNameRequired;

  /// No description provided for @colorLabel.
  ///
  /// In pt, this message translates to:
  /// **'Cor'**
  String get colorLabel;

  /// No description provided for @iconLabel.
  ///
  /// In pt, this message translates to:
  /// **'Ícone'**
  String get iconLabel;

  /// No description provided for @setAsDefault.
  ///
  /// In pt, this message translates to:
  /// **'Definir como padrão'**
  String get setAsDefault;

  /// No description provided for @createEnvironmentButton.
  ///
  /// In pt, this message translates to:
  /// **'CRIAR AMBIENTE'**
  String get createEnvironmentButton;

  /// No description provided for @saveChangesButton.
  ///
  /// In pt, this message translates to:
  /// **'SALVAR ALTERAÇÕES'**
  String get saveChangesButton;

  /// No description provided for @saveError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar: {error}'**
  String saveError(String error);

  /// No description provided for @resetPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recuperar Senha'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu email para receber um link de redefinição de senha.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao enviar email. Verifique o endereço.'**
  String get resetPasswordError;

  /// No description provided for @sendLinkButton.
  ///
  /// In pt, this message translates to:
  /// **'Enviar Link'**
  String get sendLinkButton;

  /// No description provided for @emailSentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Email Enviado!'**
  String get emailSentTitle;

  /// No description provided for @emailSentMessage.
  ///
  /// In pt, this message translates to:
  /// **'Verifique sua caixa de entrada (e spam) para redefinir sua senha.'**
  String get emailSentMessage;

  /// No description provided for @gotIt.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get gotIt;

  /// No description provided for @errorMessage.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {error}'**
  String errorMessage(Object error);

  /// No description provided for @addExpenseTitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar Despesa'**
  String get addExpenseTitle;

  /// No description provided for @addIncomeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar Receita'**
  String get addIncomeTitle;

  /// No description provided for @fixedTransactionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Transações Fixas (Preenchimento Rápido)'**
  String get fixedTransactionsTitle;

  /// No description provided for @amountLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor'**
  String get amountLabel;

  /// No description provided for @quickValuesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Valores rápidos'**
  String get quickValuesTitle;

  /// No description provided for @categoryLabel.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get categoryLabel;

  /// No description provided for @selectCategoryError.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma categoria'**
  String get selectCategoryError;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria disponível'**
  String get noCategoriesAvailable;

  /// No description provided for @createCategoriesFirst.
  ///
  /// In pt, this message translates to:
  /// **'Crie categorias primeiro em \"Categorias\"'**
  String get createCategoriesFirst;

  /// No description provided for @descriptionOptionalLabel.
  ///
  /// In pt, this message translates to:
  /// **'Descrição (Opcional)'**
  String get descriptionOptionalLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Compra no supermercado'**
  String get descriptionHint;

  /// No description provided for @dateLabel.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get dateLabel;

  /// No description provided for @today.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @invalidAmountError.
  ///
  /// In pt, this message translates to:
  /// **'Digite um valor válido'**
  String get invalidAmountError;

  /// No description provided for @expenseAddedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Despesa adicionada com sucesso!'**
  String get expenseAddedSuccess;

  /// No description provided for @incomeAddedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Receita adicionada com sucesso!'**
  String get incomeAddedSuccess;

  /// No description provided for @addTransactionError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao adicionar. Tente novamente.'**
  String get addTransactionError;

  /// No description provided for @myGoalsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meus Objetivos'**
  String get myGoalsTitle;

  /// No description provided for @goalsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Defina metas e acompanhe seu progresso'**
  String get goalsSubtitle;

  /// No description provided for @goalsLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar objetivos: {error}'**
  String goalsLoadError(String error);

  /// No description provided for @noGoalsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum objetivo definido'**
  String get noGoalsTitle;

  /// No description provided for @noGoalsMessage.
  ///
  /// In pt, this message translates to:
  /// **'Crie metas para economizar\ne alcançar seus sonhos'**
  String get noGoalsMessage;

  /// No description provided for @createGoalButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar objetivo'**
  String get createGoalButton;

  /// No description provided for @userUnidentifiedError.
  ///
  /// In pt, this message translates to:
  /// **'Erro: Usuário não identificado'**
  String get userUnidentifiedError;

  /// No description provided for @addValueTitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar valor'**
  String get addValueTitle;

  /// No description provided for @valueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor (R\$)'**
  String get valueLabel;

  /// No description provided for @addButton.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get addButton;

  /// No description provided for @deleteGoalTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir objetivo'**
  String get deleteGoalTitle;

  /// No description provided for @deleteGoalMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir \"{goalName}\"?'**
  String deleteGoalMessage(String goalName);

  /// No description provided for @newGoalTitle.
  ///
  /// In pt, this message translates to:
  /// **'Novo Objetivo'**
  String get newGoalTitle;

  /// No description provided for @goalNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome do objetivo'**
  String get goalNameLabel;

  /// No description provided for @goalNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Viagem para praia'**
  String get goalNameHint;

  /// No description provided for @goalNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite um nome'**
  String get goalNameRequired;

  /// No description provided for @targetAmountLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor alvo'**
  String get targetAmountLabel;

  /// No description provided for @targetAmountRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite um valor'**
  String get targetAmountRequired;

  /// No description provided for @deadlineDateLabel.
  ///
  /// In pt, this message translates to:
  /// **'Data limite'**
  String get deadlineDateLabel;

  /// No description provided for @daysRemaining.
  ///
  /// In pt, this message translates to:
  /// **'{days} dias'**
  String daysRemaining(int days);

  /// No description provided for @createGoalError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao criar objetivo: {error}'**
  String createGoalError(Object error);

  /// No description provided for @goalCreatedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Objetivo criado com sucesso!'**
  String get goalCreatedSuccess;

  /// No description provided for @goalCompletedStatus.
  ///
  /// In pt, this message translates to:
  /// **'Concluído!'**
  String get goalCompletedStatus;

  /// No description provided for @goalOverdueStatus.
  ///
  /// In pt, this message translates to:
  /// **'Atrasado'**
  String get goalOverdueStatus;

  /// No description provided for @daysRemainingSuffix.
  ///
  /// In pt, this message translates to:
  /// **'{days} dias restantes'**
  String daysRemainingSuffix(int days);

  /// No description provided for @goalProgressOf.
  ///
  /// In pt, this message translates to:
  /// **'de'**
  String get goalProgressOf;

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir transação'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionMessage.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja excluir esta transação?'**
  String get deleteTransactionMessage;

  /// No description provided for @deleteButton.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get deleteButton;

  /// No description provided for @filterLabel.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar'**
  String get filterLabel;

  /// No description provided for @fixedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Fixas'**
  String get fixedLabel;

  /// No description provided for @adjustFiltersTip.
  ///
  /// In pt, this message translates to:
  /// **'Tente ajustar os filtros'**
  String get adjustFiltersTip;

  /// No description provided for @tapToAddTip.
  ///
  /// In pt, this message translates to:
  /// **'Toque no + para adicionar'**
  String get tapToAddTip;

  /// No description provided for @viewOnlyLabel.
  ///
  /// In pt, this message translates to:
  /// **'Apenas visualização'**
  String get viewOnlyLabel;

  /// No description provided for @yourExpensesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Suas despesas'**
  String get yourExpensesTitle;

  /// No description provided for @yourIncomeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Suas receitas'**
  String get yourIncomeTitle;

  /// No description provided for @noExpenseFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma despesa encontrada'**
  String get noExpenseFound;

  /// No description provided for @noIncomeFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma receita encontrada'**
  String get noIncomeFound;

  /// No description provided for @noExpenseRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma despesa registrada'**
  String get noExpenseRegistered;

  /// No description provided for @noIncomeRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma receita registrada'**
  String get noIncomeRegistered;

  /// No description provided for @noExpenseThisMonth.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma despesa neste mês'**
  String get noExpenseThisMonth;

  /// No description provided for @noIncomeThisMonth.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma receita neste mês'**
  String get noIncomeThisMonth;

  /// No description provided for @filterExpensesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar Despesas'**
  String get filterExpensesTitle;

  /// No description provided for @filterIncomeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar Receitas'**
  String get filterIncomeTitle;

  /// No description provided for @cleanFilters.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get cleanFilters;

  /// No description provided for @periodLabel.
  ///
  /// In pt, this message translates to:
  /// **'Período'**
  String get periodLabel;

  /// No description provided for @dateFrom.
  ///
  /// In pt, this message translates to:
  /// **'De'**
  String get dateFrom;

  /// No description provided for @dateTo.
  ///
  /// In pt, this message translates to:
  /// **'Até'**
  String get dateTo;

  /// No description provided for @minLabel.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In pt, this message translates to:
  /// **'Máximo'**
  String get maxLabel;

  /// No description provided for @categoriesLabel.
  ///
  /// In pt, this message translates to:
  /// **'Categorias'**
  String get categoriesLabel;

  /// No description provided for @noCategoriesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria encontrada.'**
  String get noCategoriesFound;

  /// No description provided for @applyFiltersButton.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar Filtros'**
  String get applyFiltersButton;

  /// No description provided for @expenseCategoriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Categorias de Despesas'**
  String get expenseCategoriesTitle;

  /// No description provided for @incomeCategoriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Categorias de Receitas'**
  String get incomeCategoriesTitle;

  /// No description provided for @newCategoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova categoria'**
  String get newCategoryTitle;

  /// No description provided for @categoryNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome da categoria'**
  String get categoryNameHint;

  /// No description provided for @selectIconLabel.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um ícone'**
  String get selectIconLabel;

  /// No description provided for @addCategoryButton.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar categoria'**
  String get addCategoryButton;

  /// No description provided for @yourCategoriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Suas categorias'**
  String get yourCategoriesTitle;

  /// No description provided for @noCategoriesCreated.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria criada'**
  String get noCategoriesCreated;

  /// No description provided for @addCategoriesAboveTip.
  ///
  /// In pt, this message translates to:
  /// **'Adicione categorias acima'**
  String get addCategoriesAboveTip;

  /// No description provided for @editCategoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar categoria'**
  String get editCategoryTitle;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir categoria'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir \"{name}\"?'**
  String deleteCategoryMessage(String name);

  /// No description provided for @enterCategoryNameError.
  ///
  /// In pt, this message translates to:
  /// **'Digite o nome da categoria'**
  String get enterCategoryNameError;

  /// No description provided for @categoryAddedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Categoria adicionada!'**
  String get categoryAddedSuccess;

  /// No description provided for @addCategoryError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao adicionar categoria'**
  String get addCategoryError;

  /// No description provided for @enterValidValue.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, digite um valor válido'**
  String get enterValidValue;

  /// No description provided for @templateSavedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Template salvo com sucesso!'**
  String get templateSavedSuccess;

  /// No description provided for @saveErrorMessage.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar. Verifique sua conexão ou permissões.'**
  String get saveErrorMessage;

  /// No description provided for @fixedExpensesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Despesas Fixas'**
  String get fixedExpensesTitle;

  /// No description provided for @fixedIncomeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Receitas Fixas'**
  String get fixedIncomeTitle;

  /// No description provided for @manageTemplatesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Gerencie seus modelos de preenchimento'**
  String get manageTemplatesSubtitle;

  /// No description provided for @createNewFixedButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar Nova Fixa'**
  String get createNewFixedButton;

  /// No description provided for @loadError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar dados'**
  String get loadError;

  /// No description provided for @permissionOrIndexError.
  ///
  /// In pt, this message translates to:
  /// **'Isso pode ser falta de permissão ou índice no Firebase.'**
  String get permissionOrIndexError;

  /// No description provided for @noTemplatesFound.
  ///
  /// In pt, this message translates to:
  /// **'Sem modelos salvos'**
  String get noTemplatesFound;

  /// No description provided for @createTemplatesTip.
  ///
  /// In pt, this message translates to:
  /// **'Crie templates para agilizar o lançamento de contas recorrentes como aluguel, salário, etc.'**
  String get createTemplatesTip;

  /// No description provided for @deleteTemplateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir?'**
  String get deleteTemplateTitle;

  /// No description provided for @deleteTemplateMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja remover este modelo?'**
  String get deleteTemplateMessage;

  /// No description provided for @templateRemoved.
  ///
  /// In pt, this message translates to:
  /// **'Modelo removido'**
  String get templateRemoved;

  /// No description provided for @defaultAmountLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor Padrão'**
  String get defaultAmountLabel;

  /// No description provided for @saveTemplateButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar Template'**
  String get saveTemplateButton;

  /// No description provided for @drawerMyProfile.
  ///
  /// In pt, this message translates to:
  /// **'Meu Perfil'**
  String get drawerMyProfile;

  /// No description provided for @drawerHelp.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda'**
  String get drawerHelp;

  /// No description provided for @drawerAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre o iQoin'**
  String get drawerAbout;

  /// No description provided for @drawerSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get drawerSettings;

  /// No description provided for @drawerLogout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get drawerLogout;

  /// No description provided for @drawerLogoutConfirmTitle.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Saída'**
  String get drawerLogoutConfirmTitle;

  /// No description provided for @drawerLogoutConfirmMessage.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja desconectar sua conta?'**
  String get drawerLogoutConfirmMessage;

  /// No description provided for @drawerVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão'**
  String get drawerVersion;

  /// No description provided for @notificationsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Central de Avisos'**
  String get notificationsTitle;

  /// No description provided for @notificationsUnread.
  ///
  /// In pt, this message translates to:
  /// **'{count} não lidas'**
  String notificationsUnread(int count);

  /// No description provided for @notificationsAllRead.
  ///
  /// In pt, this message translates to:
  /// **'Todas lidas'**
  String get notificationsAllRead;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In pt, this message translates to:
  /// **'Ler todas'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tudo tranquilo'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In pt, this message translates to:
  /// **'Você não tem novas notificações no momento.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationsConnectionError.
  ///
  /// In pt, this message translates to:
  /// **'Erro de Conexão'**
  String get notificationsConnectionError;

  /// No description provided for @notificationsErrorHint.
  ///
  /// In pt, this message translates to:
  /// **'Verifique se o índice foi criado no Firebase.'**
  String get notificationsErrorHint;

  /// No description provided for @timeYesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get timeYesterday;

  /// No description provided for @profileTitle.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar Perfil'**
  String get profileEdit;

  /// No description provided for @profileTagLabel.
  ///
  /// In pt, this message translates to:
  /// **'Sua Tag (ID de Usuário)'**
  String get profileTagLabel;

  /// No description provided for @profileTagCopied.
  ///
  /// In pt, this message translates to:
  /// **'Tag copiada!'**
  String get profileTagCopied;

  /// No description provided for @profileGeneratingId.
  ///
  /// In pt, this message translates to:
  /// **'Gerando ID...'**
  String get profileGeneratingId;

  /// No description provided for @profileNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get profileNameLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In pt, this message translates to:
  /// **'Telefone'**
  String get profilePhoneLabel;

  /// No description provided for @profilePhoneHint.
  ///
  /// In pt, this message translates to:
  /// **'Adicione seu telefone'**
  String get profilePhoneHint;

  /// No description provided for @profileBirthDateLabel.
  ///
  /// In pt, this message translates to:
  /// **'Data de Nascimento'**
  String get profileBirthDateLabel;

  /// No description provided for @profileGenderLabel.
  ///
  /// In pt, this message translates to:
  /// **'Gênero'**
  String get profileGenderLabel;

  /// No description provided for @profileGenderSelect.
  ///
  /// In pt, this message translates to:
  /// **'Selecione'**
  String get profileGenderSelect;

  /// No description provided for @profileGenderMale.
  ///
  /// In pt, this message translates to:
  /// **'Masculino'**
  String get profileGenderMale;

  /// No description provided for @profileGenderFemale.
  ///
  /// In pt, this message translates to:
  /// **'Feminino'**
  String get profileGenderFemale;

  /// No description provided for @profileGenderOther.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get profileGenderOther;

  /// No description provided for @profileGenderPreferNotToSay.
  ///
  /// In pt, this message translates to:
  /// **'Prefiro não informar'**
  String get profileGenderPreferNotToSay;

  /// No description provided for @profileSaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar alterações'**
  String get profileSaveButton;

  /// No description provided for @profileDeleteAccountTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta'**
  String get profileDeleteAccountTitle;

  /// No description provided for @profileDeleteAccountSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Remover permanentemente seus dados'**
  String get profileDeleteAccountSubtitle;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar sessão neste dispositivo'**
  String get profileLogoutSubtitle;

  /// No description provided for @profilePhotoGallery.
  ///
  /// In pt, this message translates to:
  /// **'Galeria'**
  String get profilePhotoGallery;

  /// No description provided for @profilePhotoCamera.
  ///
  /// In pt, this message translates to:
  /// **'Câmera'**
  String get profilePhotoCamera;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Foto de perfil atualizada!'**
  String get profilePhotoUpdated;

  /// No description provided for @profileUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Perfil atualizado!'**
  String get profileUpdated;

  /// No description provided for @profileDeleteConfirmMessage.
  ///
  /// In pt, this message translates to:
  /// **'Esta ação é irreversível. Todos os seus dados serão perdidos. Deseja continuar?'**
  String get profileDeleteConfirmMessage;

  /// No description provided for @subscriptionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Minhas Assinaturas'**
  String get subscriptionsTitle;

  /// No description provided for @subscriptionsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe seus gastos recorrentes'**
  String get subscriptionsSubtitle;

  /// No description provided for @subscriptionsTotalMonthly.
  ///
  /// In pt, this message translates to:
  /// **'Total mensal'**
  String get subscriptionsTotalMonthly;

  /// No description provided for @subscriptionsActiveCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} ativas'**
  String subscriptionsActiveCount(int count);

  /// No description provided for @subscriptionsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma assinatura cadastrada'**
  String get subscriptionsEmptyTitle;

  /// No description provided for @subscriptionsEmptyMessage.
  ///
  /// In pt, this message translates to:
  /// **'Adicione suas assinaturas\npara acompanhar os gastos'**
  String get subscriptionsEmptyMessage;

  /// No description provided for @subscriptionsAddButton.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar assinatura'**
  String get subscriptionsAddButton;

  /// No description provided for @subscriptionsDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir assinatura'**
  String get subscriptionsDeleteTitle;

  /// No description provided for @subscriptionsDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir \"{name}\"?'**
  String subscriptionsDeleteMessage(String name);

  /// No description provided for @newSubscriptionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova Assinatura'**
  String get newSubscriptionTitle;

  /// No description provided for @subscriptionNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome da assinatura'**
  String get subscriptionNameLabel;

  /// No description provided for @subscriptionNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Netflix, Spotify'**
  String get subscriptionNameHint;

  /// No description provided for @subscriptionNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite um nome'**
  String get subscriptionNameRequired;

  /// No description provided for @subscriptionFrequencyLabel.
  ///
  /// In pt, this message translates to:
  /// **'Frequência'**
  String get subscriptionFrequencyLabel;

  /// No description provided for @subscriptionBillingDayLabel.
  ///
  /// In pt, this message translates to:
  /// **'Dia de cobrança'**
  String get subscriptionBillingDayLabel;

  /// No description provided for @subscriptionIconLabel.
  ///
  /// In pt, this message translates to:
  /// **'Ícone'**
  String get subscriptionIconLabel;

  /// No description provided for @subscriptionAddedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura adicionada!'**
  String get subscriptionAddedSuccess;

  /// No description provided for @dashboardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dashboards'**
  String get dashboardTitle;

  /// No description provided for @dashboardMonthlyOverview.
  ///
  /// In pt, this message translates to:
  /// **'Visão Geral Mensal'**
  String get dashboardMonthlyOverview;

  /// No description provided for @dashboardExpenseByCategory.
  ///
  /// In pt, this message translates to:
  /// **'Despesas por Categoria'**
  String get dashboardExpenseByCategory;

  /// No description provided for @dashboardIncomeByCategory.
  ///
  /// In pt, this message translates to:
  /// **'Receitas por Categoria'**
  String get dashboardIncomeByCategory;

  /// No description provided for @dashboardNoData.
  ///
  /// In pt, this message translates to:
  /// **'Sem dados para exibir'**
  String get dashboardNoData;

  /// No description provided for @dashboardTouchDetails.
  ///
  /// In pt, this message translates to:
  /// **'Segure para ver detalhes'**
  String get dashboardTouchDetails;

  /// No description provided for @aboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get aboutTitle;

  /// No description provided for @aboutDescriptionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua ferramenta completa para'**
  String get aboutDescriptionTitle;

  /// No description provided for @aboutDescriptionSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'gerenciamento financeiro pessoal'**
  String get aboutDescriptionSubtitle;

  /// No description provided for @aboutDescriptionBody.
  ///
  /// In pt, this message translates to:
  /// **'Controle suas receitas, despesas, e alcance seus objetivos financeiros de forma simples e intuitiva.'**
  String get aboutDescriptionBody;

  /// No description provided for @aboutFeatureExpenses.
  ///
  /// In pt, this message translates to:
  /// **'Receitas & Despesas'**
  String get aboutFeatureExpenses;

  /// No description provided for @aboutFeatureExpensesDesc.
  ///
  /// In pt, this message translates to:
  /// **'Registre e categorize suas transações'**
  String get aboutFeatureExpensesDesc;

  /// No description provided for @aboutFeatureGoals.
  ///
  /// In pt, this message translates to:
  /// **'Objetivos'**
  String get aboutFeatureGoals;

  /// No description provided for @aboutFeatureGoalsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Defina metas de economia e investimento'**
  String get aboutFeatureGoalsDesc;

  /// No description provided for @aboutFeatureSubscriptions.
  ///
  /// In pt, this message translates to:
  /// **'Inscrições'**
  String get aboutFeatureSubscriptions;

  /// No description provided for @aboutFeatureSubscriptionsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe suas assinaturas recorrentes'**
  String get aboutFeatureSubscriptionsDesc;

  /// No description provided for @aboutCopyright.
  ///
  /// In pt, this message translates to:
  /// **'© 2026 iQoin. Todos os direitos reservados.'**
  String get aboutCopyright;

  /// No description provided for @categoriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Categorias'**
  String get categoriesTitle;

  /// No description provided for @categoriesTabExpenses.
  ///
  /// In pt, this message translates to:
  /// **'Despesas'**
  String get categoriesTabExpenses;

  /// No description provided for @categoriesTabIncome.
  ///
  /// In pt, this message translates to:
  /// **'Receitas'**
  String get categoriesTabIncome;

  /// No description provided for @categoriesNewCategory.
  ///
  /// In pt, this message translates to:
  /// **'Nova Categoria'**
  String get categoriesNewCategory;

  /// No description provided for @categoriesEditCategory.
  ///
  /// In pt, this message translates to:
  /// **'Editar Categoria'**
  String get categoriesEditCategory;

  /// No description provided for @categoriesHistoryTip.
  ///
  /// In pt, this message translates to:
  /// **'Toque em uma categoria para ver o histórico'**
  String get categoriesHistoryTip;

  /// No description provided for @categoriesLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar categorias'**
  String get categoriesLoadError;

  /// No description provided for @categoriesEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria encontrada'**
  String get categoriesEmpty;

  /// No description provided for @categoriesDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir categoria?'**
  String get categoriesDeleteTitle;

  /// No description provided for @categoriesDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Isso não excluirá as transações existentes.'**
  String get categoriesDeleteMessage;

  /// No description provided for @categoriesDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Categoria \"{name}\" excluída'**
  String categoriesDeleted(String name);

  /// No description provided for @categoriesNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome da categoria'**
  String get categoriesNameHint;

  /// No description provided for @categoriesSaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar Alterações'**
  String get categoriesSaveButton;

  /// No description provided for @categoriesAddButton.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get categoriesAddButton;

  /// No description provided for @helpTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda e FAQ'**
  String get helpTitle;

  /// No description provided for @helpHeaderTitle.
  ///
  /// In pt, this message translates to:
  /// **'Como podemos ajudar?'**
  String get helpHeaderTitle;

  /// No description provided for @helpHeaderSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Confira as perguntas frequentes abaixo'**
  String get helpHeaderSubtitle;

  /// No description provided for @helpContactTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ainda tem dúvidas?'**
  String get helpContactTitle;

  /// No description provided for @helpContactSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Entre em contato com o suporte'**
  String get helpContactSubtitle;

  /// No description provided for @helpWhatsappButton.
  ///
  /// In pt, this message translates to:
  /// **'Fale Conosco no WhatsApp'**
  String get helpWhatsappButton;

  /// No description provided for @helpWhatsappError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir o WhatsApp'**
  String get helpWhatsappError;

  /// No description provided for @helpFaq1Question.
  ///
  /// In pt, this message translates to:
  /// **'Como adiciono uma nova transação?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In pt, this message translates to:
  /// **'Na tela inicial, toque na aba \"Despesas\" ou \"Receitas\" e use o botão \"+\" no canto inferior direito. Preencha os dados e salve.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In pt, this message translates to:
  /// **'Posso editar uma transação?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In pt, this message translates to:
  /// **'Atualmente, para garantir a integridade dos dados, recomendamos excluir a transação incorreta (deslizando para a esquerda) e criar uma nova.'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In pt, this message translates to:
  /// **'Como funcionam os Objetivos?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In pt, this message translates to:
  /// **'Na aba \"Objetivos\", você pode criar metas financeiras (ex: Viagem, Carro). Defina um valor alvo e adicione economias progressivamente para acompanhar seu progresso visualmente.'**
  String get helpFaq3Answer;

  /// No description provided for @helpFaq4Question.
  ///
  /// In pt, this message translates to:
  /// **'O que são as Inscrições?'**
  String get helpFaq4Question;

  /// No description provided for @helpFaq4Answer.
  ///
  /// In pt, this message translates to:
  /// **'A aba \"Inscrições\" serve para listar seus gastos recorrentes (Netflix, Spotify, Academia). Isso ajuda a visualizar quanto do seu orçamento mensal já está comprometido.'**
  String get helpFaq4Answer;

  /// No description provided for @helpFaq5Question.
  ///
  /// In pt, this message translates to:
  /// **'Meus dados estão seguros?'**
  String get helpFaq5Question;

  /// No description provided for @helpFaq5Answer.
  ///
  /// In pt, this message translates to:
  /// **'Sim! Seus dados são armazenados na nuvem do Google (Firebase) com autenticação segura. Apenas você tem acesso às suas informações.'**
  String get helpFaq5Answer;

  /// No description provided for @helpFaq6Question.
  ///
  /// In pt, this message translates to:
  /// **'Como altero minha senha?'**
  String get helpFaq6Question;

  /// No description provided for @helpFaq6Answer.
  ///
  /// In pt, this message translates to:
  /// **'Vá até o menu lateral, toque em \"Perfil\" e selecione a opção \"Alterar senha\". Um email de redefinição será enviado para você.'**
  String get helpFaq6Answer;

  /// No description provided for @tabDashboard.
  ///
  /// In pt, this message translates to:
  /// **'Dash'**
  String get tabDashboard;

  /// No description provided for @tabGoals.
  ///
  /// In pt, this message translates to:
  /// **'Metas'**
  String get tabGoals;

  /// No description provided for @tabHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get tabHome;

  /// No description provided for @tabCategories.
  ///
  /// In pt, this message translates to:
  /// **'Categ.'**
  String get tabCategories;

  /// No description provided for @tabSubscriptions.
  ///
  /// In pt, this message translates to:
  /// **'Inscr.'**
  String get tabSubscriptions;

  /// No description provided for @settingsReplayTutorial.
  ///
  /// In pt, this message translates to:
  /// **'Rever Tutorial'**
  String get settingsReplayTutorial;

  /// No description provided for @onboardingTitle1.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe seus gastos'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In pt, this message translates to:
  /// **'Tenha controle total de suas finanças com gráficos detalhados e categorias personalizadas.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In pt, this message translates to:
  /// **'Defina metas inteligentes'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In pt, this message translates to:
  /// **'Conquiste seus sonhos criando metas e acompanhando seu progresso mês a mês.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In pt, this message translates to:
  /// **'Assinaturas e Alertas'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In pt, this message translates to:
  /// **'Gerencie seus serviços recorrentes e receba lembretes antes do vencimento.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get onboardingGetStarted;

  /// No description provided for @next.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In pt, this message translates to:
  /// **'Pular'**
  String get skip;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
