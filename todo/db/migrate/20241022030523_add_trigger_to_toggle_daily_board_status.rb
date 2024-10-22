class AddTriggerToToggleDailyBoardStatus < ActiveRecord::Migration[7.0]
  def up
    # Cria a função que será usada pela trigger
    execute <<-SQL
      CREATE OR REPLACE FUNCTION toggle_daily_board_status() 
      RETURNS TRIGGER AS $$
      BEGIN
        -- Se o campo show_daily_board foi alterado
        IF NEW.show_daily_board = TRUE THEN
          -- Ativa o 'Board Diário' se ele existir para o usuário
          UPDATE boards 
          SET active = TRUE
          WHERE title = 'Board Diário' AND user_id = NEW.id;
        ELSE
          -- Desativa o 'Board Diário' se o show_daily_board for FALSE
          UPDATE boards 
          SET active = FALSE
          WHERE title = 'Board Diário' AND user_id = NEW.id;
        END IF;

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    # Cria a trigger associada
    execute <<-SQL
      CREATE TRIGGER update_daily_board_status
      AFTER UPDATE OF show_daily_board
      ON users
      FOR EACH ROW
      WHEN (OLD.show_daily_board IS DISTINCT FROM NEW.show_daily_board)
      EXECUTE FUNCTION toggle_daily_board_status();
    SQL
  end

  def down
    # Remove a trigger e a função se você fizer rollback da migration
    execute <<-SQL
      DROP TRIGGER IF EXISTS update_daily_board_status ON users;
      DROP FUNCTION IF EXISTS toggle_daily_board_status();
    SQL
  end
end
