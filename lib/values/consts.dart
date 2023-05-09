enum GptModels {
  davinci('text-davinci-003'),
  gpt3('gpt-3.5-turbo'),
  gpt4('gpt-4');

  const GptModels(this.name);

  final String name;
}
