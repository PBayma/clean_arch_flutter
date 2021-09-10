import 'package:clean_flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_flutter_tdd/features/number_trivia/presentation/widgets/loading_display.dart';
import 'package:clean_flutter_tdd/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:clean_flutter_tdd/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:clean_flutter_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  final TextEditingController numberTriviaController = TextEditingController();
  NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serverLocal<NumberTriviaBloc>(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                if (state is EmptyNumberTriviaState) {
                  return const MessageDisplay(message: 'Start Searching');
                } else if (state is ErrorNumberTriviaState) {
                  return MessageDisplay(message: state.message);
                } else if (state is LoadedNumberTriviaState) {
                  return TriviaDisplay(numberTrivia: state.numberTrivia);
                }
                return const LoadingDisplay();
              }),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write your number here',
                      ),
                      controller: numberTriviaController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () => _getConcreteTrivia(
                                context, numberTriviaController.text),
                            child: const Text('Search Number')),
                        ElevatedButton(
                            onPressed: () => _getRandomTrivia(context),
                            child: const Text('Get Random Trivia')),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

void _getRandomTrivia(BuildContext context) {
  BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
}

void _getConcreteTrivia(BuildContext context, String numberString) {
  BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForConcreteNumber(numberString));
}
