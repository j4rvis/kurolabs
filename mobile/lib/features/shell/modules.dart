import 'package:flutter/material.dart';
import 'package:kurolabs_hub/kurolabs_hub.dart';
import 'package:omoi_module/omoi_module.dart';
import 'package:questify_module/questify_module.dart';
import 'package:user_management_module/user_management_module.dart';

/// All vertical modules registered in the shell.
/// Add new entries here when a new vertical is created.
const List<ModuleConfig> registeredModules = [
  omoiModule,
  questifyModule,
  userManagementModule,
];
