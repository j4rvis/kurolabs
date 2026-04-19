/// Primary library file for the Questify module.
///
/// Exports the [questifyModule] ModuleConfig for registration with the shell,
/// and [questifyRoutes] for inclusion in the top-level go_router config.
library questify_module;

export 'modules/questify/questify_module_config.dart';
export 'modules/questify/questify_routes.dart';
