import 'package:invest_analize/entities/aquisition_entity.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';

abstract class PersistenceRepository {
  Future<void> init();

  Future<SymbolEntity> insertAquisition(AcquisitionEntity aquisition,
      SymbolEntity symbolEntity, ValueEntity value);
  Future<List<SymbolEntity>> getAquisitionsWallet();
  Future<SymbolEntity> deletSymbol(SymbolEntity symbolEntity);
  Future<ValueEntity> insertValue(ValueEntity value);
}
