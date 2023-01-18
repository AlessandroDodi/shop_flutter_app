import 'package:flutter/material.dart';
import 'package:shop_flutter_app/providers/product.dart';

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
  var _editProduct =
      Product(description: '', id: '', imageUrl: '', price: 0, title: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState?.save();
    print(_editProduct.title);
    print(_editProduct.description);
    print(_editProduct.price);
    print(_editProduct.imageUrl);
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: Padding(
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
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  onSaved: (value) {
                    _editProduct = Product(
                      title: value ?? '',
                      description: _editProduct.description,
                      price: _editProduct.price,
                      id: _editProduct.id,
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                  focusNode: _priceFocusNode,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editProduct = Product(
                      title: _editProduct.title,
                      description: _editProduct.description,
                      price: double.parse(value!),
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
                  onSaved: (value) {
                    _editProduct = Product(
                      title: _editProduct.title,
                      description: value ?? '',
                      price: _editProduct.price,
                      id: _editProduct.id,
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
                                  errorBuilder: (context, error, stackTrace) =>
                                      Text(''),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          onFieldSubmitted: (_) => _saveForm(),
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            _editProduct = Product(
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              id: _editProduct.id,
                              imageUrl: value ?? '',
                            );
                          },
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
