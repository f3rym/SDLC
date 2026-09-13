package by.bsuir.lr1.model;

public final class InvertResult {

    private final String invertedSentence;
    private final int wordCount;
    private final int letterCount;
    private final String longestWord;

    public InvertResult(String invertedSentence, int wordCount, int letterCount, String longestWord) {
        this.invertedSentence = invertedSentence;
        this.wordCount = wordCount;
        this.letterCount = letterCount;
        this.longestWord = longestWord;
    }

    public String getInvertedSentence() {
        return invertedSentence;
    }

    public int getWordCount() {
        return wordCount;
    }

    public int getLetterCount() {
        return letterCount;
    }

    public String getLongestWord() {
        return longestWord;
    }
}
