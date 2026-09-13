package by.bsuir.lr1.view;

import by.bsuir.lr1.model.InvertResult;
import by.bsuir.lr1.model.ModelListener;
import by.bsuir.lr1.model.SentenceModel;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;

public class MainFrame extends JFrame implements ModelListener {

    private final JTextArea sourceArea = readOnlyArea();
    private final JTextArea resultArea = readOnlyArea();
    private final JLabel wordCountLabel = new JLabel("—");
    private final JLabel letterCountLabel = new JLabel("—");
    private final JLabel longestWordLabel = new JLabel("—");

    private final JButton enterDataButton = new JButton("Ввести данные");

    private ViewActionHandler actionHandler;

    public MainFrame() {
        super("Инвертирование слов");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        buildLayout();
        pack();
        setLocationRelativeTo(null);
    }

    public void setActionHandler(ViewActionHandler handler) {
        this.actionHandler = handler;
    }

    public void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Ошибка ввода", JOptionPane.ERROR_MESSAGE);
    }

    @Override
    public void modelChanged(SentenceModel model) {
        sourceArea.setText(model.getSentence());

        InvertResult r = model.getResult();
        resultArea.setText(r.getInvertedSentence());
        wordCountLabel.setText(String.valueOf(r.getWordCount()));
        letterCountLabel.setText(String.valueOf(r.getLetterCount()));
        longestWordLabel.setText(r.getLongestWord());
    }

    private void buildLayout() {
        JPanel root = new JPanel(new BorderLayout(10, 10));
        root.setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));

        JLabel title = new JLabel("Утилита инвертирования слов");
        title.setFont(title.getFont().deriveFont(Font.BOLD, 16f));
        root.add(title, BorderLayout.NORTH);

        JPanel center = new JPanel(new GridLayout(0, 1, 0, 6));
        center.add(new JLabel("Введённое предложение:"));
        center.add(scroll(sourceArea));
        center.add(new JLabel("Предложение с инвертированными словами:"));
        center.add(scroll(resultArea));

        JPanel stats = new JPanel(new GridLayout(0, 2, 10, 4));
        addRow(stats, "Слов обработано:", wordCountLabel);
        addRow(stats, "Букв и цифр в словах:", letterCountLabel);
        addRow(stats, "Самое длинное слово:", longestWordLabel);
        center.add(stats);
        root.add(center, BorderLayout.CENTER);

        enterDataButton.addActionListener(e -> {
            if (actionHandler != null) {
                actionHandler.onEnterDataRequested();
            }
        });
        JPanel buttons = new JPanel();
        buttons.add(enterDataButton);
        root.add(buttons, BorderLayout.SOUTH);

        setContentPane(root);
    }

    private static JTextArea readOnlyArea() {
        JTextArea area = new JTextArea(3, 40);
        area.setEditable(false);
        area.setLineWrap(true);
        area.setWrapStyleWord(true);
        return area;
    }

    private static JScrollPane scroll(JTextArea area) {
        JScrollPane pane = new JScrollPane(area);
        pane.setPreferredSize(new Dimension(450, 70));
        return pane;
    }

    private static void addRow(JPanel grid, String caption, JLabel value) {
        grid.add(new JLabel(caption));
        value.setFont(value.getFont().deriveFont(Font.BOLD));
        grid.add(value);
    }
}
