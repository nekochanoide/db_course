CREATE OR REPLACE PACKAGE BODY Сотрудник_API AS PROCEDURE Автоинкремент(Запись IN OUT ТЗапись) IS BEGIN
SELECT ПЗ_СОТРУДНИК.nextval INTO Запись.ИД_сотрудника
FROM DUAL;
END;
PROCEDURE Добавить(
    Запись IN OUT ТЗапись,
    ВыпДобавлние IN BOOLEAN DEFAULT TRUE
) AS Временный_ИД INTEGER;
BEGIN вызов_из_пакета := TRUE;
IF ВыпДобавлние THEN Автоинкремент(Запись);
SELECT ИД_человека INTO Временный_ИД
FROM сотрудник
WHERE ИД_человека = Запись.ИД_человека;
IF Временный_ИД = Запись.ИД_человека THEN RAISE_APPLICATION_ERROR(
    -20005,
    'Человек не может работать более чем на одной должности.'
);
END IF;
INSERT INTO Сотрудник (
        ИД_сотрудника,
        ИД_человека,
        ИД_поликлиники,
        Табельный_номер,
        Специализация
    )
VALUES (
        Запись.ИД_сотрудника,
        Запись.ИД_человека,
        Запись.ИД_поликлиники,
        Запись.Табельный_номер,
        Запись.Специализация
    );
Выбрать(Запись);
END IF;
вызов_из_пакета := FALSE;
EXCEPTION
WHEN NO_DATA_FOUND THEN
INSERT INTO Сотрудник (
        ИД_сотрудника,
        ИД_человека,
        ИД_поликлиники,
        Табельный_номер,
        Специализация
    )
VALUES (
        Запись.ИД_сотрудника,
        Запись.ИД_человека,
        Запись.ИД_поликлиники,
        Запись.Табельный_номер,
        Запись.Специализация
    );
Выбрать(Запись);
WHEN OTHERS THEN вызов_из_пакета := FALSE;
raise;
--ВЫЗОВ ПРОЦЕДУРЫ-ОБРАБОТЧИКА
END;
PROCEDURE Изменить(
    Запись IN OUT ТЗапись,
    ВыпИзменение IN BOOLEAN DEFAULT TRUE
) AS Временный_ИД INTEGER;
BEGIN вызов_из_пакета := TRUE;
IF ВыпИзменение THEN IF Запись.ид_строки IS NULL THEN
SELECT ИД_человека INTO Временный_ИД
FROM человек
WHERE ИД_человека = Запись.ИД_человека;
IF Временный_ИД = Запись.ИД_человека THEN RAISE_APPLICATION_ERROR(
    -20005,
    'Человек не может работать более чем на одной должности.'
);
END IF;
UPDATE Сотрудник
SET ИД_сотрудника = Запись.ИД_сотрудника,
    ИД_человека = Запись.ИД_человека,
    ИД_поликлиники = Запись.ИД_поликлиники,
    Табельный_номер = Запись.Табельный_номер,
    Специализация = Запись.Специализация
WHERE ИД_сотрудника = Запись.ИД_сотрудника;
ELSE
UPDATE Сотрудник
SET ИД_сотрудника = Запись.ИД_сотрудника,
    ИД_человека = Запись.ИД_человека,
    ИД_поликлиники = Запись.ИД_поликлиники,
    Табельный_номер = Запись.Табельный_номер,
    Специализация = Запись.Специализация
WHERE rowid = Запись.ид_строки;
END IF;
END IF;
вызов_из_пакета := FALSE;
EXCEPTION
WHEN OTHERS THEN вызов_из_пакета := FALSE;
raise;
--ВЫЗОВ ПРОЦЕДУРЫ-ОБРАБОТЧИКА
END;
END;
/
CREATE OR REPLACE PACKAGE BODY Обследование_API AS PROCEDURE Автоинкремент(Запись IN OUT ТЗапись) IS BEGIN
SELECT ПЗ_ОБСЛЕДОВАНИЕ.nextval INTO Запись.ИД_обследования
FROM DUAL;
END;
PROCEDURE Добавить(
    Запись IN OUT ТЗапись,
    ВыпДобавлние IN BOOLEAN DEFAULT TRUE
) AS Врем_ИД_сотр INTEGER;
Врем_ИД_паци INTEGER;
BEGIN вызов_из_пакета := TRUE;
IF ВыпДобавлние THEN Автоинкремент(Запись);
SELECT ИД_поликлиники INTO Врем_ИД_сотр
FROM сотрудник
WHERE ИД_сотрудника = Запись.ИД_сотрудника;
SELECT ИД_поликлиники INTO Врем_ИД_паци
FROM Пациент
WHERE ИД_пациента = Запись.ИД_пациента;
IF Врем_ИД_сотр <> Врем_ИД_паци THEN RAISE_APPLICATION_ERROR(
    -20006,
    'Пациента не может обследовать врач из другой поликлиники.'
);
END IF;
INSERT INTO Обследование (
        ИД_обследования,
        ИД_пациента,
        ИД_сотрудника,
        Дата
    )
VALUES (
        Запись.ИД_обследования,
        Запись.ИД_пациента,
        Запись.ИД_сотрудника,
        Запись.Дата
    );
Выбрать(Запись);
END IF;
вызов_из_пакета := FALSE;
EXCEPTION
WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20008, 'Указанный ID не существут');
WHEN OTHERS THEN вызов_из_пакета := FALSE;
raise;
--ВЫЗОВ ПРОЦЕДУРЫ-ОБРАБОТЧИКА
END;
PROCEDURE Изменить(
    Запись IN OUT ТЗапись,
    ВыпИзменение IN BOOLEAN DEFAULT TRUE
) AS Врем_ИД_сотр INTEGER;
Врем_ИД_паци INTEGER;
BEGIN вызов_из_пакета := TRUE;
IF ВыпИзменение THEN
SELECT ИД_поликлиники INTO Врем_ИД_сотр
FROM сотрудник
WHERE ИД_сотрудника = Запись.ИД_сотрудника;
SELECT ИД_поликлиники INTO Врем_ИД_паци
FROM Пациент
WHERE ИД_пациента = Запись.ИД_пациента;
IF Врем_ИД_сотр <> Врем_ИД_паци THEN RAISE_APPLICATION_ERROR(
    -20006,
    'Пациента не может обследовать врач из другой поликлиники.'
);
END IF;
IF Запись.ид_строки IS NULL THEN
UPDATE Обследование
SET ИД_обследования = Запись.ИД_обследования,
    ИД_пациента = Запись.ИД_пациента,
    ИД_сотрудника = Запись.ИД_сотрудника,
    Дата = Запись.Дата
WHERE ИД_обследования = Запись.ИД_обследования;
ELSE
UPDATE Обследование
SET ИД_обследования = Запись.ИД_обследования,
    ИД_пациента = Запись.ИД_пациента,
    ИД_сотрудника = Запись.ИД_сотрудника,
    Дата = Запись.Дата
WHERE rowid = Запись.ид_строки;
END IF;
END IF;
вызов_из_пакета := FALSE;
EXCEPTION
WHEN OTHERS THEN вызов_из_пакета := FALSE;
raise;
--ВЫЗОВ ПРОЦЕДУРЫ-ОБРАБОТЧИКА
END;
END;
/
CREATE OR REPLACE PACKAGE BODY Направление_API AS PROCEDURE Автоинкремент(Запись IN OUT ТЗапись) IS BEGIN
SELECT ПЗ_НАПРАВЛЕНИЕ.nextval INTO Запись.ИД_направления
FROM DUAL;
END;
PROCEDURE Добавить(
    Запись IN OUT ТЗапись,
    ВыпДобавлние IN BOOLEAN DEFAULT TRUE
) AS Временная_дата DATE;
BEGIN вызов_из_пакета := TRUE;
IF ВыпДобавлние THEN
SELECT Дата INTO Временная_дата
FROM обследование
WHERE Обследование.ИД_обследования = Запись.ИД_обследования;
IF Запись.Дата_выдачи < Временная_дата THEN RAISE_APPLICATION_ERROR(
    -20000,
    'Дата выдачи направления должна быть не раньше даты обследования'
);
END IF;
SELECT sysdate() INTO Временная_дата
FROM DUAL;
IF Запись.Дата_выдачи > Временная_дата THEN RAISE_APPLICATION_ERROR(
    -20000,
    'Неверно введена дата выдачи направления: дата в будущем.'
);
END IF;
Автоинкремент(Запись);
INSERT INTO Направление (
        ИД_направления,
        ИД_обследования,
        Дата_выдачи,
        Обследование
    )
VALUES (
        Запись.ИД_направления,
        Запись.ИД_обследования,
        Запись.Дата_выдачи,
        Запись.Обследование
    );
Выбрать(Запись);
END IF;
вызов_из_пакета := FALSE;
EXCEPTION
WHEN OTHERS THEN вызов_из_пакета := FALSE;
raise;
--ВЫЗОВ ПРОЦЕДУРЫ-ОБРАБОТЧИКА
END;
PROCEDURE Изменить(
    Запись IN OUT ТЗапись,
    ВыпИзменение IN BOOLEAN DEFAULT TRUE
) AS Временная_дата DATE;
BEGIN вызов_из_пакета := TRUE;
IF ВыпИзменение THEN
SELECT Дата INTO Временная_дата
FROM обследование
WHERE Обследование.ИД_обследования = Запись.ИД_обследования;
IF Запись.Дата_выдачи < Временная_дата THEN RAISE_APPLICATION_ERROR(
    -20000,
    'Дата выдачи направления должна быть не раньше даты обследования'
);
END IF;
IF Запись.ид_строки IS NULL THEN
UPDATE Направление
SET ИД_направления = Запись.ИД_направления,
    ИД_обследования = Запись.ИД_обследования,
    Дата_выдачи = Запись.Дата_выдачи,
    Обследование = Запись.Обследование
WHERE ИД_направления = Запись.ИД_направления;
ELSE
UPDATE Направление
SET ИД_направления = Запись.ИД_направления,
    ИД_обследования = Запись.ИД_обследования,
    Дата_выдачи = Запись.Дата_выдачи,
    Обследование = Запись.Обследование
WHERE rowid = Запись.ид_строки;
END IF;
END IF;
вызов_из_пакета := FALSE;
EXCEPTION
WHEN OTHERS THEN вызов_из_пакета := FALSE;
raise;
--ВЫЗОВ ПРОЦЕДУРЫ-ОБРАБОТЧИКА
END;
END;