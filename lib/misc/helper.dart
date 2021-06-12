List openTodos = [];
List completedTodos = [];

void addCompletedTodo(element) {
  completedTodos.add(element);
}

void changeEntry(index, text) {
  openTodos[index] = text;
}

void uncompleteTodo(element) {
  openTodos.add(element);
}
