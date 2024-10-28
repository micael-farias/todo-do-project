CREATE OR REPLACE FUNCTION public.toggle_daily_board_status()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  -- Se o campo show_daily_board foi alterado
  IF NEW.show_daily_board = TRUE THEN
    -- Ativa o 'Board diário' se ele existir para o usuário
    UPDATE boards 
    SET active = TRUE
    WHERE daily = TRUE AND user_id = NEW.user_id;
  ELSE
    -- Desativa o 'Board diário' se o show_daily_board for FALSE
    UPDATE boards 
    SET active = FALSE
    WHERE daily = TRUE AND user_id = NEW.user_id;
  END IF;

  RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.toggle_daily_board_status()
    OWNER TO admin;


CREATE OR REPLACE TRIGGER update_daily_board_status
    AFTER UPDATE OF show_daily_board
    ON public.user_preferences
    FOR EACH ROW
    WHEN (OLD.show_daily_board IS DISTINCT FROM NEW.show_daily_board)
    EXECUTE FUNCTION public.toggle_daily_board_status();
