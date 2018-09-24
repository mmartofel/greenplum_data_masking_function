-- Author: Igor Putyatin, Pivotal

CREATE OR REPLACE FUNCTION mask_optimized (OrigVal VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
   NewVal VARCHAR ='';
   OrigLen INT;
   PartStartIndex INT; -- MaskStartIndex

BEGIN
    OrigLen := length(OrigVal);
    PartStartIndex := least((OrigLen-1)/4,3);
    NewVal = substr(OrigVal, 1, PartStartIndex)||repeat('X',OrigLen-2*PartStartIndex)||substr(OrigVal, OrigLen-PartStartIndex+1, PartStartIndex);
    return NewVal;
END
$$
LANGUAGE 'plpgsql' immutable;
