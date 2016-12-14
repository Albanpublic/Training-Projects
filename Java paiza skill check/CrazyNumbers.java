package normalTraining;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

enum Letters {

	a(0, "a"), b(1, "b"), c(2, "c"), d(3, "d"), e(4, "e"), f(5, "f"), g(6, "g"), h(7, "h"), i(8, "i"), 
	j(9, "j"), k(10, "k"), l(11, "l"), m(12, "m"), n(13, "n"), o(14, "o"), p(15, "p"), q(16, "q"),
	r(17, "r"), s(18, "s"), t(19, "t"), u(20, "u"), v(21, "v"), w(22, "w"), x(23, "x"), y(24, "y"), z(25, "z");
	
	private int number;
	private String letter;
	
	//Setting the variables associated with the Enums.
	Letters (int number, String letter){
		this.number = number;
		this.letter = letter;
	}
	
	//Returning the number associated with the Letter.
	public int getNumberValue(){
		return number;
	}
	//Returning the letter associated with the number.
	public String getLetter(){
		return letter;
	}
	
}


public class CrazyNumbers {
	
	private static long[] alphabet = new long[26];
	private static Letters[] letters = Letters.values();
//	private static String input = "abcd10(e3(2g10(z1000(hx(ww))i)dg)5q)3f";
//	private static String testInput = "10000(10000(1#0000(2000(ab)500(dz)c200h)2mu3000(fpr)))";

	public static void main(String[] args) throws IOException {
		

		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String line = br.readLine().trim();
		
		String input = line;
		//input = input.toLowerCase();
		
//		System.out.println("input is " + input);
//		System.out.println();
		Pattern check = Pattern.compile("[^a-z0-9()]");
		Matcher checkMatch = check.matcher(input);
		boolean unwantedCharacter = checkMatch.find();
		
		if(unwantedCharacter || !correctBrackets(input)){
			System.out.println("unwanted character(s) or not matching brackets");
		}else{
			execute(input);
		}
	}
	
	//Original algorithm using recursion.
	
//	static String treatString(String str){
//		System.out.println("String entering is " + str);
//		
//		if(isParenthesis(str) && lastSetOfParenthesis(str)){
//			
//			str = multiplyParenthesis(str);
//			System.out.println("inside of the if, starting to go back with the String " + str);
//			
//			return str;
//		}else{
//			
//		String result = (str.replace(secondTrim(str), treatString(secondTrim(str))));
//		
//		result = multiplyParenthesis(result);
//		
//		
//		return result;
//		}
//	}
	
	//Return true if there is any bracket(opening) in the string
	static boolean isBrackets(String string){
		
		if(string.indexOf('(') == -1){
			return false;
		}else{
			return true;
		}
	}
	//Return the index of the first opening bracket
	static int firstBracket(String string){
		
		return string.indexOf('(');
	}
	//Return the index of the last closing bracket
	static int lastBracket(String string){
		return string.lastIndexOf(')');
	}
	//Return the number before the bracket
	static int numberBeforeBrackets(String string){
		
		Pattern regex = Pattern.compile("\\d+(?=\\()");
		Matcher m = regex.matcher(string);
		
		if(m.find()){
			return Integer.parseInt(m.group());
		}
		return 1;
	}
	//Check if all bracket pairs
	static Boolean correctBrackets(String string){
		if(string.isEmpty()){
			return true;
		}else{
			
			Stack<Character> stack = new Stack<>();
			char current;
			for(int i = 0; i < string.length(); i++){
				current = string.charAt(i);
				switch (current) {
				case '(':
					stack.push(current);
					break;
				case ')':
					if(stack.isEmpty())
						return false;
					stack.pop();
					break;
				default:
					break;
				}
			}
		return stack.isEmpty();
		}
		
		
	}
	//Strip the first the of parentheses but leave intact the inside.
	static String stripParenthesis(String string){
		String strippedString = string.substring(firstBracket(string) + 1, lastBracket(string));
		
		return strippedString;
	}
	
	//Multiply the inside of the bracket with the number before it
	static String multiplyParenthesis(String string){
		
		StringBuilder sb = new StringBuilder();
		long multiplicator = numberBeforeBrackets(string);
		String insideParentheseString = stripParenthesis(string);
		if(multiplicator == 1){
			return insideParentheseString;
		}
		Boolean numberFlag = false;
		String number = "";
		
		//Iterating through the string inside the parentheses.
		for(int i = 0; i < insideParentheseString.length(); i++){
			
			//Checking if the character is a digit and adding it to number.
			if(Character.isDigit(insideParentheseString.charAt(i))){
				number = number.concat(String.valueOf(insideParentheseString.charAt(i)));
				numberFlag = true;
				
			//If the character is a letter and there is a number before it, multiply it.
			}else if(!Character.isDigit(insideParentheseString.charAt(i)) && numberFlag == true){
				sb.append(multiplicator * Long.parseLong(number));
				sb.append(insideParentheseString.charAt(i));
				number = "";
				numberFlag = false;
				
			//If the character is a letter and there is no number before it, simply add it to the sb.
			}else{
				sb.append(multiplicator);
				sb.append(insideParentheseString.charAt(i));
			}
		}
		return sb.toString();
	}

	static void printResults(){
		
		for(int i = 0; i < 26; i++){
			System.out.println(letters[i].getLetter() + " " + alphabet[i]);
		}
	}

	static void count(String input){
		String number = "1";
		Boolean defaultNumber = true;
		char character;
		
		for(int i = 0; i < input.length(); i++){
			character = input.charAt(i);
			switch(character){
				case 'a': 
					alphabet[0] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'b': 
					alphabet[1] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'c': 
					alphabet[2] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'd': 
					alphabet[3] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'e': 
					alphabet[4] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'f': 
					alphabet[5] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'g': 
					alphabet[6] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'h': 
					alphabet[7] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'i': 
					alphabet[8] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'j': 
					alphabet[9] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'k': 
					alphabet[10] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'l': 
					alphabet[11] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'm': 
					alphabet[12] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'n': 
					alphabet[13] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'o': 
					alphabet[14] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'p': 
					alphabet[15] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'q': 
					alphabet[16] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'r': 
					alphabet[17] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 's': 
					alphabet[18] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 't': 
					alphabet[19] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'u': 
					alphabet[20] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'v': 
					alphabet[21] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'w': 
					alphabet[22] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'x': 
					alphabet[23] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'y': 
					alphabet[24] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				case 'z': 
					alphabet[25] += Long.parseLong(number);
					number = "1";
					defaultNumber = true;
					break;
				default:
					if(defaultNumber){
						number = String.valueOf(character);
						defaultNumber = false;
					}else{
						number = number.concat(String.valueOf(character));
					}
					
					break;
				
			}
		}
	}
	static void execute(String input){

		//Pattern for any inside brackets.
		//Pattern regex = Pattern.compile("\\([^()]*\\)");

		//Pattern for any inside brackets and the preceding number.
		Pattern regex = Pattern.compile("[0-9]+\\([^()]*\\)|\\([^()]*\\)");

		//Loop until there is no brackets
		while(isBrackets(input)){

			//Match any inside brackets
			Matcher m = regex.matcher(input);

			//For any brackets
			while(m.find()){

				//Replace the bracket with multiplied result
				input = input.replace(m.group(), multiplyParenthesis(m.group()));
			}

		}
		count(input);
		printResults();
	}

}
