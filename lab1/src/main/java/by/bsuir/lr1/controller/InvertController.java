package by.bsuir.lr1.controller;

import by.bsuir.lr1.model.SentenceModel;
import by.bsuir.lr1.view.InputDialog;
import by.bsuir.lr1.view.MainFrame;
import by.bsuir.lr1.view.ViewActionHandler;

public class InvertController implements ViewActionHandler {

    private static final int MAX_LENGTH = 500;

    private final SentenceModel model;
    private final MainFrame view;

    public InvertController(SentenceModel model, MainFrame view) {
        this.model = model;
        this.view = view;
    }

    @Override
    public void onEnterDataRequested() {
        InputDialog dialog = new InputDialog(view);

        String last = model.getSentence();
        if (last != null) {
            dialog.setSentence(last);
        }

        dialog.setVisible(true);
        if (!dialog.isConfirmed()) {
            return;
        }

        try {
            String sentence = validate(dialog.getSentenceText());
            model.setSentence(sentence);
        } catch (IllegalArgumentException ex) {
            view.showError(ex.getMessage());
        }
    }

    static String validate(String text) {
        String trimmed = text == null ? "" : text.trim();
        if (trimmed.isEmpty()) {
            throw new IllegalArgumentException("Предложение не введено");
        }
        if (trimmed.length() > MAX_LENGTH) {
            throw new IllegalArgumentException("Предложение слишком длинное: "
                    + trimmed.length() + " символов, допустимо не более " + MAX_LENGTH);
        }
        boolean hasLetterOrDigit = trimmed.chars().anyMatch(Character::isLetterOrDigit);
        if (!hasLetterOrDigit) {
            throw new IllegalArgumentException("В предложении нет ни одного слова: «" + trimmed + "»");
        }
        return trimmed;
    }
}
