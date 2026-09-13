package by.bsuir.lr1.model;

import java.util.ArrayList;
import java.util.List;

public class SentenceModel {

    private String sentence;
    private InvertResult result;

    private final List<ModelListener> listeners = new ArrayList<>();

    public void addListener(ModelListener listener) {
        listeners.add(listener);
    }

    public void removeListener(ModelListener listener) {
        listeners.remove(listener);
    }

    private void fireModelChanged() {
        for (ModelListener listener : listeners) {
            listener.modelChanged(this);
        }
    }

    public String getSentence() {
        return sentence;
    }

    public InvertResult getResult() {
        return result;
    }

    public void setSentence(String sentence) {
        this.sentence = sentence;
        this.result = invert(sentence);
        fireModelChanged();
    }

    static InvertResult invert(String sentence) {
        StringBuilder out = new StringBuilder(sentence.length());
        StringBuilder word = new StringBuilder();
        int wordCount = 0;
        int letterCount = 0;
        String longest = "";

        for (int i = 0; i <= sentence.length(); i++) {

            char c = i < sentence.length() ? sentence.charAt(i) : ' ';

            if (Character.isLetterOrDigit(c)) {
                word.append(c);
            } else {
                if (word.length() > 0) {
                    wordCount++;
                    letterCount += word.length();
                    if (word.length() > longest.length()) {
                        longest = word.toString();
                    }
                    out.append(word.reverse());
                    word.setLength(0);
                }
                if (i < sentence.length()) {
                    out.append(c);
                }
            }
        }
        return new InvertResult(out.toString(), wordCount, letterCount, longest);
    }
}
