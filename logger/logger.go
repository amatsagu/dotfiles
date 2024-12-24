package logger

import "fmt"

const reset = "\033[0m"
const red = "\033[31m"
const green = "\033[32m"
const yellow = "\033[33m"
const gray = "\033[36m"

func Text(s string) {
	fmt.Println(s)
}

func SubText(s string) {
	fmt.Println(gray + s + reset)
}

func Warn(s string) {
	fmt.Println(yellow + s + reset)
}

func Error(s string) {
	fmt.Println(red + s + reset)
}

func Success(s string) {
	fmt.Println(green + s + reset)
}
