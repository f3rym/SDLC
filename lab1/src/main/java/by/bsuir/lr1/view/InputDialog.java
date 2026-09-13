package by.bsuir.lr1.view;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import java.awt.BorderLayout;

public class InputDialog extends JDialog {

    private final JTextArea sentenceArea = new JTextArea(4, 40);

    private boolean confirmed;

    public InputDialog(JFrame owner) {
        super(owner, "Ввод предложения", true);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        JPanel root = new JPanel(new BorderLayout(10, 10));
        root.setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));

        root.add(new JLabel("Введите предложение:"), BorderLayout.NORTH);

        sentenceArea.setLineWrap(true);
        sentenceArea.setWrapStyleWord(true);
        root.add(new JScrollPane(sentenceArea), BorderLayout.CENTER);

        JButton okButton = new JButton("ОК");
        JButton cancelButton = new JButton("Отмена");
        okButton.addActionListener(e -> {
            confirmed = true;
            dispose();
        });
        cancelButton.addActionListener(e -> dispose());

        JPanel buttons = new JPanel();
        buttons.add(okButton);
        buttons.add(cancelButton);
        root.add(buttons, BorderLayout.SOUTH);

        getRootPane().setDefaultButton(okButton);
        setContentPane(root);
        pack();
        setLocationRelativeTo(owner);
    }

    public void setSentence(String sentence) {
        sentenceArea.setText(sentence);
        sentenceArea.selectAll();
    }

    public boolean isConfirmed() {
        return confirmed;
    }

    public String getSentenceText() {
        return sentenceArea.getText();
    }
}
