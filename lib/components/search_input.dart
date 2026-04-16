import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? hintText;

  const SearchInput({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearText() {
    _controller.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Ürün ara...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 20,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                  onPressed: _clearText,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
