import 'package:clean_flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_flutter_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => serverLocal<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: const Placeholder(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Write your number here',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: Text('Search Number')),
                        ElevatedButton(
                            onPressed: () {}, child: Text('Random Number')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
