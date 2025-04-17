import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/GeoLocationProvider/Geoprovider.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAddressField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
 final bool? enabled ;
  const CustomAddressField({
    Key? key,
    this.enabled,
    required this.controller,
    required this.label,
    
    required this.prefixIcon,
    this.validator,
  }) : super(key: key);

  @override
  _CustomAddressFieldState createState() => _CustomAddressFieldState();
}

class _CustomAddressFieldState extends ConsumerState<CustomAddressField> {
  late TextEditingController _controller;
  final String _currentInput = '';
 
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onAddressChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAddressChanged);
    super.dispose();
  }

  void _onAddressChanged() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      ref.read(geoLocationProvider.notifier).fetchAddressSuggestions(query);
      setState(() {
        _isDropdownVisible = true;
      });
    } else {
      setState(() {
        _isDropdownVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = ref.watch(geoLocationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address input field
        CustomTextField(
          isEnabled: widget.enabled==true,
          label: "Address",
          controller: _controller,
          validator: widget.validator,
        ),
       if (_isDropdownVisible && suggestions.isNotEmpty)
  Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    constraints: const BoxConstraints(maxHeight: 200), // 👈 limits dropdown height
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final address = suggestions[index];
        return ListTile(
          titleTextStyle: const TextStyle(
            fontSize:18,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
          title: Text(address),
          onTap: () {
            _controller.text = address;
            setState(() {
              _isDropdownVisible = false;
            });
          },
        );
      },
    ),
  ),

      ],
    );
  }
}
