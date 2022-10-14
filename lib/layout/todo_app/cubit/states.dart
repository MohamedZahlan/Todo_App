abstract class TodoStates {}

class TodoInitialState extends TodoStates{}

class TodoChangeScreenState extends TodoStates{}

class TodoLoadingState extends TodoStates{}

class TodoCreateDataBase extends TodoStates{}

class TodoInsertToDataBase extends TodoStates{}

class TodoGetFromDataBase extends TodoStates{}

class TodoChangeBottomSheetState extends TodoStates{}

class TodoUpdateToDataBaseState extends TodoStates{}

class TodoDeleteFromDataBaseState extends TodoStates{}

class TodoChangeAppModeState extends TodoStates{}