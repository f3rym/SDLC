package by.bsuir.lr1;

import by.bsuir.lr1.controller.InvertController;
import by.bsuir.lr1.model.SentenceModel;
import by.bsuir.lr1.view.MainFrame;

import javax.swing.SwingUtilities;

public final class Main {

    private Main() {
    }

    public static void main(String[] args) {

        SwingUtilities.invokeLater(() -> {
            SentenceModel model = new SentenceModel();
            MainFrame view = new MainFrame();
            InvertController controller = new InvertController(model, view);

            model.addListener(view);
            view.setActionHandler(controller);

            view.setVisible(true);
        });
    }
}
