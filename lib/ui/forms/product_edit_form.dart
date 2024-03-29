import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/components/metric_card.dart';

class ProductEditForm extends StatefulWidget {

  final bool isNew;
  final Product product;

  const ProductEditForm({Key? key, required this.product, required this.isNew}) : super(key: key);

  @override
  State<ProductEditForm> createState() => _ProductEditFormState();
}

class _ProductEditFormState extends State<ProductEditForm> {

  final _productFormKey = GlobalKey<FormState>();
  late TextEditingController productNameTextController = TextEditingController(text: widget.product.name);
  late TextEditingController productDescriptionTextController = TextEditingController(text: widget.product.description);
  late TextEditingController productUnitPriceTextController = TextEditingController(text: '${widget.product.unitBasePrice}');
  late TextEditingController bottleSizeTextController = TextEditingController(text: '${widget.product.unitSize}');
  late TextEditingController unitsInPackTextController = TextEditingController(text: '${widget.product.unitsInPack}');

  @override
  void initState() {
    super.initState();
    productNameTextController.addListener(() {
      widget.product.name = productNameTextController.value.text;
    });
    productDescriptionTextController.addListener(() {
      widget.product.description = productDescriptionTextController.value.text;
    });
    productUnitPriceTextController.addListener(() {
      widget.product.unitBasePrice = int.parse(productUnitPriceTextController.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {

    var textTheme = Theme.of(context).textTheme;

    return Form(
      key: _productFormKey,
      child: SizedBox(
        width: 500,
        child: MetricCard(
            horizontalPadding: 20,
            verticalPadding: 20,
            body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.isNew ? 'Créer un nouveau produit' : 'Modifier un produit', style: textTheme.headlineSmall)),
                  const SizedBox(height: 20),
                  BasicContainer(
                    child: TextFormField(
                      controller: productNameTextController,
                      maxLength: 20,
                      decoration: const InputDecoration(label: Text('Nom du produit')),
                      validator: (value) {
                        if (StringUtils.isNullOrEmpty(value)) {
                          return 'Vous devez mettre un nom de produit';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  BasicContainer(
                    child: TextFormField(
                      controller: productDescriptionTextController,
                      maxLength: 60,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          label: Text('Déscription')),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BasicContainer(
                    child: TextFormField(
                      controller: productUnitPriceTextController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('Prix unitaire de base'),
                          suffix: Text('MT')),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ce produit est stockable?', style: textTheme.titleMedium),
                          Text('Ex: Le remplissage d\'un bidon vide est un produit non-stockable', style: textTheme.labelSmall)
                        ],
                      ),
                      Switch(
                          value: widget.product.isStockable,
                          inactiveThumbColor: Colors.black45,
                          inactiveTrackColor: Colors.grey[200],
                          onChanged: (bool newValue) => setState(() => widget.product.isStockable = newValue)),
                    ],
                  ),
                  Visibility(
                    visible: widget.product.isStockable,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        BasicContainer(
                          child: TextFormField(
                            controller: bottleSizeTextController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text('Taille d\'une bouteille'),
                                suffix: Text('littres')),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BasicContainer(
                          child: TextFormField(
                            controller: unitsInPackTextController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text('Nombre de bouteilles dans un pack'),
                                suffix: Text('bouteilles')),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  FilledButton(
                      onPressed: () {
                        if (_productFormKey.currentState!.validate()) {
                          if (widget.isNew) {
                            ProductsService().createNew(widget.product.uuid, widget.product);
                          } else {
                            widget.product.save();
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Sauvegarder'))
                ])),
      ),
    );
  }
}
