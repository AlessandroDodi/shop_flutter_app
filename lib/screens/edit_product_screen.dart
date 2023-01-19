import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _editProduct =
      Product(description: '', id: '', imageUrl: '', price: 0, title: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop();
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error occured'),
            content: const Text('Something went wrong'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String? productId =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editProduct = product;
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': _editProduct.imageUrl,
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product page'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: ((value) {
                          if (value == null || value == '') {
                            return 'Please provide a valid title';
                          }
                          return null;
                        }),
                        textInputAction: TextInputAction.next,
                        initialValue: _initValues['title'],
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (value) {
                          _editProduct = Product(
                            title: value ?? '',
                            description: _editProduct.description,
                            price: _editProduct.price,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                        initialValue: _initValues['price'],
                        validator: ((value) {
                          if (value == null) return 'Please provide a price';
                          if (double.tryParse(value) == null) {
                            return 'Please provide  a valid price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please provide a positive price';
                          }
                          return null;
                        }),
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editProduct = Product(
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: double.tryParse(value!) ?? 0,
                            id: _editProduct.id,
                            imageUrl: _editProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        initialValue: _initValues['description'],
                        validator: ((value) {
                          if (value == null || value == '') {
                            return 'Please provide a valid description';
                          }
                          return null;
                        }),
                        onSaved: (value) {
                          _editProduct = Product(
                            title: _editProduct.title,
                            description: value ?? '',
                            price: _editProduct.price,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                          );
                        },
                        focusNode: _descriptionFocusNode,
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            child: Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(
                                top: 20,
                                right: 10,
                              ),
                              // decoration: BoxDecoration(
                              //     border: Border.all(width: 1, color: Colors.grey),
                              //     borderRadius: BorderRadius.circular(20)),
                              child: _imageUrlController.text.isEmpty
                                  ? const Center(child: Text('Enter a URL'))
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Text(''),
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                onFieldSubmitted: (_) => _saveForm(),
                                textInputAction: TextInputAction.done,
                                onSaved: (value) {
                                  _editProduct = Product(
                                    title: _editProduct.title,
                                    isFavorite: _editProduct.isFavorite,
                                    description: _editProduct.description,
                                    price: _editProduct.price,
                                    id: _editProduct.id,
                                    imageUrl: value ?? '',
                                  );
                                },
                                validator: ((value) {
                                  if (value == null || value == '') {
                                    return 'Please provide a valid image';
                                  }
                                  return null;
                                }),
                                controller: _imageUrlController,
                                onEditingComplete: () {
                                  setState(() {});
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
